#requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TexPath,

    [ValidateRange(1, 2)]
    [int]$Passes = 1
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-JsonResult {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Result,

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
    if (-not [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
        $standardMiKTeXPath = Join-Path $env:LOCALAPPDATA 'Programs\MiKTeX\miktex\bin\x64\pdflatex.exe'
        if ([System.IO.File]::Exists($standardMiKTeXPath)) {
            return $standardMiKTeXPath
        }
    }

    $pathCommand = Get-Command pdflatex -ErrorAction SilentlyContinue
    if ($null -ne $pathCommand) {
        return $pathCommand.Source
    }

    throw 'pdflatex was not found at the standard MiKTeX location or on PATH.'
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
    $script:RepositoryRoot = [System.IO.Path]::GetFullPath(
        (Join-Path $PSScriptRoot '..\..\..\..')
    )
    $outputRoot = [System.IO.Path]::GetFullPath((Join-Path $script:RepositoryRoot 'output'))
    $resolvedTexPath = Resolve-RepositoryPath $TexPath

    if (-not [System.IO.File]::Exists($resolvedTexPath)) {
        throw "Cover-letter source not found: $resolvedTexPath"
    }

    if (-not (Test-IsWithinDirectory -Path $resolvedTexPath -Directory $outputRoot)) {
        throw "The cover-letter source must be located under $outputRoot"
    }

    if (-not $resolvedTexPath.EndsWith('.tex', [System.StringComparison]::OrdinalIgnoreCase)) {
        throw 'TexPath must point to a .tex file.'
    }

    $sourceStem = [System.IO.Path]::GetFileNameWithoutExtension($resolvedTexPath)
    if ($sourceStem -notmatch '^Cover_Letter_[A-Za-z0-9][A-Za-z0-9._-]*$') {
        throw 'The cover-letter filename must start with Cover_Letter_ and contain only letters, digits, dots, underscores, or hyphens.'
    }

    $outputDirectory = [System.IO.Path]::GetDirectoryName($resolvedTexPath)
    $sourceFileName = [System.IO.Path]::GetFileName($resolvedTexPath)
    $artifactStem = $sourceStem
    $versionNumber = $null
    $versionReason = $null

    $standardArtifactExtensions = @('pdf', 'aux', 'log', 'out', 'toc', 'fls', 'fdb_latexmk', 'synctex.gz')
    $lockedStandardArtifacts = @(
        foreach ($extension in $standardArtifactExtensions) {
            $candidate = Join-Path $outputDirectory "${sourceStem}.${extension}"
            if ([System.IO.File]::Exists($candidate) -and -not (Test-ExclusiveFileAccess -Path $candidate)) {
                $candidate
            }
        }
    )

    if ($lockedStandardArtifacts.Count -gt 0) {
        $versionPattern = '^' + [regex]::Escape($sourceStem) + '_version(?<number>\d+)\.'
        $existingVersionNumbers = @(
            Get-ChildItem -LiteralPath $outputDirectory -File -ErrorAction SilentlyContinue |
                ForEach-Object {
                    $match = [regex]::Match($_.Name, $versionPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                    if ($match.Success) {
                        [int]$match.Groups['number'].Value
                    }
                }
        )
        $versionNumber = if ($existingVersionNumbers.Count -gt 0) {
            ([int]($existingVersionNumbers | Measure-Object -Maximum).Maximum) + 1
        }
        else {
            1
        }
        $artifactStem = "${sourceStem}_version${versionNumber}"
        $versionReason = 'standard_artifact_locked'
    }

    $pdfPath = Join-Path $outputDirectory "${artifactStem}.pdf"
    $logPath = Join-Path $outputDirectory "${artifactStem}.log"
    $compiler = Resolve-PdfLatex
    $captureId = [guid]::NewGuid().ToString('N')
    $stdoutPath = Join-Path $outputDirectory ".cover-render-${captureId}.stdout"
    $stderrPath = Join-Path $outputDirectory ".cover-render-${captureId}.stderr"
    $exitCode = 0

    try {
        for ($pass = 1; $pass -le $Passes; $pass++) {
            $process = Start-Process `
                -FilePath $compiler `
                -ArgumentList @(
                    '-interaction=nonstopmode',
                    '-halt-on-error',
                    '-no-shell-escape',
                    "-jobname=${artifactStem}",
                    $sourceFileName
                ) `
                -WorkingDirectory $outputDirectory `
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
            status                 = 'error'
            tex_path               = $resolvedTexPath
            pdf_path               = if ([System.IO.File]::Exists($pdfPath)) { $pdfPath } else { $null }
            log_path               = if ([System.IO.File]::Exists($logPath)) { $logPath } else { $null }
            compiler               = $compiler
            compiler_exit_code     = $exitCode
            artifact_stem          = $artifactStem
            version                = $versionNumber
            first_actionable_error = Get-FirstLatexError $logContent
        })
    }

    $layoutWarnings = @(
        [regex]::Matches(
            $logContent,
            '(?im)^.*(?:Overfull|Underfull|LaTeX Warning|pdfTeX warning).*$'
        ) | ForEach-Object { $_.Value.Trim() }
    )

    Write-JsonResult -Result ([ordered]@{
        status                 = 'success'
        tex_path               = $resolvedTexPath
        pdf_path               = $pdfPath
        log_path               = $logPath
        compiler               = $compiler
        compiler_exit_code     = $exitCode
        artifact_stem          = $artifactStem
        version                = $versionNumber
        version_reason         = $versionReason
        page_count             = Get-PageCountFromLog $logContent
        layout_warning_count   = $layoutWarnings.Count
        layout_warnings        = $layoutWarnings
        shell_escape_disabled  = $true
    })
}
catch {
    Write-JsonResult -ExitCode 2 -Result ([ordered]@{
        status = 'error'
        error  = $_.Exception.Message
    })
}
