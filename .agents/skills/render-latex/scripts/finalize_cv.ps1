#requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory,

    [string]$DocumentName = 'CV_Kostiantyn_Pysanyi',

    [ValidateRange(1, 2147483647)]
    [int]$Version
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-JsonResult {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Result,

        [int]$ExitCode = 0
    )

    $Result | ConvertTo-Json -Depth 6 -Compress
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
    $resolvedOutputDirectory = Resolve-RepositoryPath $OutputDirectory

    if (-not (Test-IsWithinDirectory -Path $resolvedOutputDirectory -Directory $outputRoot)) {
        throw "The output directory must be located under $outputRoot"
    }

    if (-not [System.IO.Directory]::Exists($resolvedOutputDirectory)) {
        throw "Output directory not found: $resolvedOutputDirectory"
    }

    $versionPattern = '^' + [regex]::Escape($DocumentName) + '_version(?<number>\d+)\.(?<extension>.+)$'
    $versionedFiles = @(
        Get-ChildItem -LiteralPath $resolvedOutputDirectory -File |
            ForEach-Object {
                $match = [regex]::Match($_.Name, $versionPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                if ($match.Success) {
                    [pscustomobject]@{
                        File          = $_
                        VersionNumber = [int]$match.Groups['number'].Value
                        Extension     = $match.Groups['extension'].Value
                    }
                }
            }
    )

    $standardPdfPath = Join-Path $resolvedOutputDirectory "${DocumentName}.pdf"
    $standardTexPath = Join-Path $resolvedOutputDirectory "${DocumentName}.tex"
    $standardLogPath = Join-Path $resolvedOutputDirectory "${DocumentName}.log"
    $standardPageCount = if ([System.IO.File]::Exists($standardLogPath)) {
        Get-PageCountFromLog ([System.IO.File]::ReadAllText($standardLogPath))
    }
    else {
        $null
    }
    $standardIsValidated = [System.IO.File]::Exists($standardPdfPath) -and
        [System.IO.File]::Exists($standardTexPath) -and
        $null -ne $standardPageCount

    if ($versionedFiles.Count -eq 0) {
        if ($standardIsValidated) {
            Write-JsonResult -Result ([ordered]@{
                status        = 'already_standard'
                pdf_path      = $standardPdfPath
                tex_path      = $standardTexPath
                page_count    = $standardPageCount
                cleanup       = 'not_needed'
            })
        }

        throw "No validated standard PDF or versioned artifacts were found for $DocumentName"
    }

    $successfulVersions = New-Object System.Collections.Generic.List[object]
    $distinctVersionNumbers = @(
        $versionedFiles | Select-Object -ExpandProperty VersionNumber -Unique
    )
    foreach ($versionNumber in $distinctVersionNumbers) {
        $versionStem = "${DocumentName}_version${versionNumber}"
        $versionPdfPath = Join-Path $resolvedOutputDirectory "${versionStem}.pdf"
        $versionTexPath = Join-Path $resolvedOutputDirectory "${versionStem}.tex"
        $versionLogPath = Join-Path $resolvedOutputDirectory "${versionStem}.log"
        $versionPageCount = if ([System.IO.File]::Exists($versionLogPath)) {
            Get-PageCountFromLog ([System.IO.File]::ReadAllText($versionLogPath))
        }
        else {
            $null
        }

        if (
            [System.IO.File]::Exists($versionPdfPath) -and
            [System.IO.File]::Exists($versionTexPath) -and
            $null -ne $versionPageCount
        ) {
            $successfulVersions.Add([pscustomobject]@{
                VersionNumber = [int]$versionNumber
                PageCount     = [int]$versionPageCount
            })
        }
    }

    if ($successfulVersions.Count -eq 0) {
        if ($standardIsValidated) {
            $retryCleanupFailures = New-Object System.Collections.Generic.List[string]
            foreach ($versionedFile in $versionedFiles) {
                try {
                    [System.IO.File]::Delete($versionedFile.File.FullName)
                }
                catch {
                    $retryCleanupFailures.Add($versionedFile.File.FullName)
                }
            }

            $retryStatus = if ($retryCleanupFailures.Count -eq 0) { 'already_standard' } else { 'cleanup_pending' }
            Write-JsonResult -Result ([ordered]@{
                status           = $retryStatus
                pdf_path         = $standardPdfPath
                tex_path         = $standardTexPath
                page_count       = $standardPageCount
                cleanup_failures = @($retryCleanupFailures)
            })
        }

        throw "No successfully compiled version was found for $DocumentName"
    }

    $selectedVersion = if ($PSBoundParameters.ContainsKey('Version')) {
        $selected = @($successfulVersions | Where-Object { $_.VersionNumber -eq $Version })
        if ($selected.Count -eq 0) {
            throw "Version $Version is not a successfully compiled version of $DocumentName"
        }
        $Version
    }
    else {
        [int](($successfulVersions | Measure-Object -Property VersionNumber -Maximum).Maximum)
    }

    $candidateStem = "${DocumentName}_version${selectedVersion}"
    $candidateFiles = @(
        $versionedFiles |
            Where-Object { $_.VersionNumber -eq $selectedVersion } |
            Select-Object -ExpandProperty File
    )
    $candidatePdfPath = Join-Path $resolvedOutputDirectory "${candidateStem}.pdf"
    $candidateTexPath = Join-Path $resolvedOutputDirectory "${candidateStem}.tex"
    $candidateLogPath = Join-Path $resolvedOutputDirectory "${candidateStem}.log"

    if (-not [System.IO.File]::Exists($candidatePdfPath)) {
        throw "The selected version has no PDF: $candidatePdfPath"
    }

    if (-not [System.IO.File]::Exists($candidateTexPath)) {
        throw "The selected version has no merged TeX source: $candidateTexPath"
    }

    $pageCount = if ([System.IO.File]::Exists($candidateLogPath)) {
        Get-PageCountFromLog ([System.IO.File]::ReadAllText($candidateLogPath))
    }
    else {
        $null
    }

    if ($null -eq $pageCount) {
        throw "The selected version has no validated page count in its log: $candidateLogPath"
    }

    $publishableExtensions = @(
        'pdf', 'tex', 'log', 'aux', 'out', 'toc', 'fls', 'fdb_latexmk', 'synctex.gz'
    )
    $filesToPublish = @(
        $candidateFiles |
            Where-Object {
                $relativeExtension = $_.Name.Substring($candidateStem.Length + 1)
                $publishableExtensions -contains $relativeExtension
            }
    )

    $lockedDestinations = @(
        foreach ($sourceFile in $filesToPublish) {
            $relativeExtension = $sourceFile.Name.Substring($candidateStem.Length + 1)
            $destinationPath = Join-Path $resolvedOutputDirectory "${DocumentName}.${relativeExtension}"
            if (-not (Test-ExclusiveFileAccess -Path $destinationPath)) {
                $destinationPath
            }
        }
    )

    if ($lockedDestinations.Count -gt 0) {
        Write-JsonResult -ExitCode 3 -Result ([ordered]@{
            status              = 'finalization_blocked'
            reason              = 'standard_artifact_locked'
            selected_version    = $selectedVersion
            latest_pdf          = $candidatePdfPath
            locked_paths        = $lockedDestinations
            action              = "Close the locked standard file and run finalization again."
        })
    }

    $transactionId = [guid]::NewGuid().ToString('N')
    $publicationRecords = New-Object System.Collections.Generic.List[object]
    $publishedRecords = New-Object System.Collections.Generic.List[object]

    try {
        foreach ($sourceFile in $filesToPublish) {
            $relativeExtension = $sourceFile.Name.Substring($candidateStem.Length + 1)
            $destinationPath = Join-Path $resolvedOutputDirectory "${DocumentName}.${relativeExtension}"
            $stagingPath = Join-Path $resolvedOutputDirectory ".publish-${transactionId}.${relativeExtension}"
            $backupPath = Join-Path $resolvedOutputDirectory ".backup-${transactionId}.${relativeExtension}"
            $destinationExisted = [System.IO.File]::Exists($destinationPath)

            [System.IO.File]::Copy($sourceFile.FullName, $stagingPath, $true)
            if ($destinationExisted) {
                [System.IO.File]::Copy($destinationPath, $backupPath, $true)
            }

            $publicationRecords.Add([pscustomobject]@{
                Source             = $sourceFile.FullName
                Destination        = $destinationPath
                Staging            = $stagingPath
                Backup             = $backupPath
                DestinationExisted = $destinationExisted
            })
        }

        foreach ($record in $publicationRecords) {
            [System.IO.File]::Copy($record.Staging, $record.Destination, $true)
            $publishedRecords.Add($record)
        }

        $pdfHashMatches = (Get-FileHash -LiteralPath $candidatePdfPath -Algorithm SHA256).Hash -eq
            (Get-FileHash -LiteralPath $standardPdfPath -Algorithm SHA256).Hash
        $texHashMatches = (Get-FileHash -LiteralPath $candidateTexPath -Algorithm SHA256).Hash -eq
            (Get-FileHash -LiteralPath $standardTexPath -Algorithm SHA256).Hash

        if (-not $pdfHashMatches -or -not $texHashMatches) {
            throw 'Published standard files failed hash verification.'
        }
    }
    catch {
        foreach ($record in @($publishedRecords) | Sort-Object -Descending { $_.Destination }) {
            try {
                if ($record.DestinationExisted -and [System.IO.File]::Exists($record.Backup)) {
                    [System.IO.File]::Copy($record.Backup, $record.Destination, $true)
                }
                elseif (-not $record.DestinationExisted -and [System.IO.File]::Exists($record.Destination)) {
                    [System.IO.File]::Delete($record.Destination)
                }
            }
            catch {
                # Preserve the original publication error; leftover files are reported below.
            }
        }

        throw
    }
    finally {
        foreach ($record in $publicationRecords) {
            [System.IO.File]::Delete($record.Staging)
            [System.IO.File]::Delete($record.Backup)
        }
    }

    $cleanupFailures = New-Object System.Collections.Generic.List[string]
    foreach ($versionedFile in $versionedFiles) {
        try {
            [System.IO.File]::Delete($versionedFile.File.FullName)
        }
        catch {
            $cleanupFailures.Add($versionedFile.File.FullName)
        }
    }

    $finalStatus = if ($cleanupFailures.Count -eq 0) { 'success' } else { 'cleanup_pending' }

    Write-JsonResult -Result ([ordered]@{
        status                  = $finalStatus
        selected_version        = $selectedVersion
        source_pdf              = $candidatePdfPath
        pdf_path                = Join-Path $resolvedOutputDirectory "${DocumentName}.pdf"
        tex_path                = Join-Path $resolvedOutputDirectory "${DocumentName}.tex"
        page_count              = $pageCount
        approximately_one_page = ($pageCount -eq 1)
        cleanup_failures        = @($cleanupFailures)
    })
}
catch {
    Write-JsonResult -ExitCode 2 -Result ([ordered]@{
        status = 'error'
        error  = $_.Exception.Message
    })
}
