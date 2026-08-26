#requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$BodyPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory,

    [string]$DocumentName = 'CV_Kostiantyn_Pysanyi',

    [string]$PdfLatexPath,

    [ValidateRange(1, 2)]
    [int]$Passes = 1
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-JsonResult {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Result,

        [int]$ExitCode = 0
    )

    $Result | ConvertTo-Json -Depth 5 -Compress
    exit $ExitCode
}

function Resolve-RepositoryPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }

    return [System.IO.Path]::GetFullPath((Join-Path $script:RepositoryRoot $Path))
}

function Test-IsWithinDirectory {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Directory
    )

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $fullDirectory = [System.IO.Path]::GetFullPath($Directory).TrimEnd('\', '/')
    $prefix = $fullDirectory + [System.IO.Path]::DirectorySeparatorChar

    return $fullPath.Equals($fullDirectory, [System.StringComparison]::OrdinalIgnoreCase) -or
        $fullPath.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)
}

function Test-ExclusiveFileAccess {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not [System.IO.File]::Exists($Path)) {
        return $true
    }

    $stream = $null
    try {
        $stream = [System.IO.File]::Open(
            $Path,
            [System.IO.FileMode]::Open,
            [System.IO.FileAccess]::ReadWrite,
            [System.IO.FileShare]::None
        )
        return $true
    }
    catch {
        return $false
    }
    finally {
        if ($null -ne $stream) {
            $stream.Dispose()
        }
    }
}

function Resolve-PdfLatex {
    param([string]$ConfiguredPath)

    if (-not [string]::IsNullOrWhiteSpace($ConfiguredPath)) {
        if ([System.IO.File]::Exists($ConfiguredPath)) {
            return [System.IO.Path]::GetFullPath($ConfiguredPath)
        }

        $configuredCommand = Get-Command $ConfiguredPath -ErrorAction SilentlyContinue
        if ($null -ne $configuredCommand) {
            return $configuredCommand.Source
        }

        throw "The configured pdflatex executable does not exist: $ConfiguredPath"
    }

    if (-not [string]::IsNullOrWhiteSpace($env:CV_PDFLATEX)) {
        if ([System.IO.File]::Exists($env:CV_PDFLATEX)) {
            return [System.IO.Path]::GetFullPath($env:CV_PDFLATEX)
        }

        throw "CV_PDFLATEX points to a missing executable: $($env:CV_PDFLATEX)"
    }

    $pathCommand = Get-Command pdflatex -ErrorAction SilentlyContinue
    if ($null -ne $pathCommand) {
        return $pathCommand.Source
    }

    if (-not [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
        $standardMiKTeXPath = Join-Path $env:LOCALAPPDATA 'Programs\MiKTeX\miktex\bin\x64\pdflatex.exe'
        if ([System.IO.File]::Exists($standardMiKTeXPath)) {
            return $standardMiKTeXPath
        }
    }

    throw 'pdflatex was not found. Put it on PATH, set CV_PDFLATEX, or pass -PdfLatexPath.'
}

function Get-FirstLatexError {
    param([string]$LogContent)

    if ([string]::IsNullOrWhiteSpace($LogContent)) {
        return $null
    }

    $errorMatch = [regex]::Match($LogContent, '(?m)^!\s+(?<message>.+)$')
    if (-not $errorMatch.Success) {
        return $null
    }

    $lineMatch = [regex]::Match(
        $LogContent.Substring($errorMatch.Index),
        '(?m)^l\.(?<line>\d+)\s*(?<source>.*)$'
    )

    if ($lineMatch.Success) {
        return "$($errorMatch.Groups['message'].Value) at line $($lineMatch.Groups['line'].Value): $($lineMatch.Groups['source'].Value.Trim())"
    }

    return $errorMatch.Groups['message'].Value.Trim()
}

function Get-PageCountFromLog {
    param([string]$LogContent)

    if ([string]::IsNullOrWhiteSpace($LogContent)) {
        return $null
    }

    $pageMatch = [regex]::Match(
        $LogContent,
        'Output written on .+? \((?<pages>\d+) pages?[,)]',
        [System.Text.RegularExpressions.RegexOptions]::Singleline
    )

    if ($pageMatch.Success) {
        return [int]$pageMatch.Groups['pages'].Value
    }

    return $null
}

try {
    if ($DocumentName -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$' -or $DocumentName -match '_version\d+$') {
        throw 'DocumentName must be a safe base filename and must not end with _versionN.'
    }

    $script:RepositoryRoot = [System.IO.Path]::GetFullPath(
        (Join-Path $PSScriptRoot '..\..\..\..')
    )
    $outputRoot = [System.IO.Path]::GetFullPath((Join-Path $script:RepositoryRoot 'output'))
    $headerPath = [System.IO.Path]::GetFullPath((Join-Path $script:RepositoryRoot 'cv\header_cv.tex'))
    $resolvedBodyPath = Resolve-RepositoryPath $BodyPath
    $resolvedOutputDirectory = Resolve-RepositoryPath $OutputDirectory

    if (-not [System.IO.File]::Exists($headerPath)) {
        throw "Stable LaTeX header not found: $headerPath"
    }

    if (-not [System.IO.File]::Exists($resolvedBodyPath)) {
        throw "Tailored body not found: $resolvedBodyPath"
    }

    if (-not (Test-IsWithinDirectory -Path $resolvedBodyPath -Directory $outputRoot)) {
        throw "The tailored body must be located under $outputRoot"
    }

    if (-not (Test-IsWithinDirectory -Path $resolvedOutputDirectory -Directory $outputRoot)) {
        throw "The output directory must be located under $outputRoot"
    }

    [System.IO.Directory]::CreateDirectory($resolvedOutputDirectory) | Out-Null

    $versionPattern = '^' + [regex]::Escape($DocumentName) + '_version(?<number>\d+)\.'
    $existingVersionNumbers = @(
        Get-ChildItem -LiteralPath $resolvedOutputDirectory -File -ErrorAction SilentlyContinue |
            ForEach-Object {
                $match = [regex]::Match($_.Name, $versionPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                if ($match.Success) {
                    [int]$match.Groups['number'].Value
                }
            }
    )

    $versionNumber = $null
    $artifactStem = $DocumentName
    $versionReason = $null

    if ($existingVersionNumbers.Count -gt 0) {
        $versionNumber = ([int]($existingVersionNumbers | Measure-Object -Maximum).Maximum) + 1
        $artifactStem = "${DocumentName}_version${versionNumber}"
        $versionReason = 'existing_version_sequence'
    }
    else {
        $standardArtifactPattern = '^' + [regex]::Escape($DocumentName) + '\.(?:pdf|tex|aux|log|out|toc|fls|fdb_latexmk|synctex\.gz)$'
        $lockedStandardArtifacts = @(
            Get-ChildItem -LiteralPath $resolvedOutputDirectory -File -ErrorAction SilentlyContinue |
                Where-Object {
                    $_.Name -match $standardArtifactPattern -and -not (Test-ExclusiveFileAccess -Path $_.FullName)
                } |
                Select-Object -ExpandProperty FullName
        )

        if ($lockedStandardArtifacts.Count -gt 0) {
            $versionNumber = 1
            $artifactStem = "${DocumentName}_version1"
            $versionReason = 'standard_artifact_locked'
        }
    }

    $mergedTexPath = Join-Path $resolvedOutputDirectory "${artifactStem}.tex"
    $pdfPath = Join-Path $resolvedOutputDirectory "${artifactStem}.pdf"
    $logPath = Join-Path $resolvedOutputDirectory "${artifactStem}.log"

    $headerContent = [System.IO.File]::ReadAllText($headerPath)
    $bodyContent = [System.IO.File]::ReadAllText($resolvedBodyPath)
    $newline = [System.Environment]::NewLine
    $mergedContent = $headerContent.TrimEnd() + $newline + $newline +
        $bodyContent.TrimEnd() + $newline + $newline + '\end{document}' + $newline
    $utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($mergedTexPath, $mergedContent, $utf8WithoutBom)

    $compiler = Resolve-PdfLatex $PdfLatexPath
    $captureId = [guid]::NewGuid().ToString('N')
    $stdoutPath = Join-Path $resolvedOutputDirectory ".render-${captureId}.stdout"
    $stderrPath = Join-Path $resolvedOutputDirectory ".render-${captureId}.stderr"
    $exitCode = 0

    try {
        for ($pass = 1; $pass -le $Passes; $pass++) {
            $process = Start-Process `
                -FilePath $compiler `
                -ArgumentList @('-interaction=nonstopmode', '-halt-on-error', "${artifactStem}.tex") `
                -WorkingDirectory $resolvedOutputDirectory `
                -NoNewWindow `
                -Wait `
                -PassThru `
                -RedirectStandardOutput $stdoutPath `
                -RedirectStandardError $stderrPath

            $exitCode = $process.ExitCode
            if ($exitCode -ne 0) {
                break
            }
        }
    }
    finally {
        Remove-Item -LiteralPath $stdoutPath, $stderrPath -Force -ErrorAction SilentlyContinue
    }

    $logContent = if ([System.IO.File]::Exists($logPath)) {
        [System.IO.File]::ReadAllText($logPath)
    }
    else {
        ''
    }

    if ($exitCode -ne 0 -or -not [System.IO.File]::Exists($pdfPath)) {
        Write-JsonResult -ExitCode 1 -Result ([ordered]@{
            status                   = 'error'
            body_path                = $resolvedBodyPath
            tex_path                 = $mergedTexPath
            pdf_path                 = if ([System.IO.File]::Exists($pdfPath)) { $pdfPath } else { $null }
            log_path                 = if ([System.IO.File]::Exists($logPath)) { $logPath } else { $null }
            compiler                 = $compiler
            compiler_exit_code       = $exitCode
            artifact_stem            = $artifactStem
            version                  = $versionNumber
            first_actionable_error   = Get-FirstLatexError $logContent
        })
    }

    $pageCount = Get-PageCountFromLog $logContent

    Write-JsonResult -Result ([ordered]@{
        status                   = 'success'
        body_path                = $resolvedBodyPath
        tex_path                 = $mergedTexPath
        pdf_path                 = $pdfPath
        log_path                 = if ([System.IO.File]::Exists($logPath)) { $logPath } else { $null }
        compiler                 = $compiler
        compiler_exit_code       = $exitCode
        artifact_stem            = $artifactStem
        standard_document_name   = $DocumentName
        version                  = $versionNumber
        version_reason           = $versionReason
        page_count               = $pageCount
        approximately_one_page   = ($pageCount -eq 1)
    })
}
catch {
    Write-JsonResult -ExitCode 2 -Result ([ordered]@{
        status = 'error'
        error  = $_.Exception.Message
    })
}
