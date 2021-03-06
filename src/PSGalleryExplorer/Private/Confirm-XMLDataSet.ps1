<#
.SYNOPSIS
    Confirms the XML dataset file is available and not beyond the expiration time.
.DESCRIPTION
    Confirms the XML dataset file is present on the file system for use. Determines the age of the XML dataset file. Returns true if present and 9 days older or more.
.EXAMPLE
    Confirm-XMLDataSet

    Checks for XML dataset and determines if it is 9 days older or more.
.OUTPUTS
    System.Boolean
.NOTES
    Used for PSGalleryExplorer
.COMPONENT
    PSGalleryExplorer
#>
function Confirm-XMLDataSet {
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best
    $dataFile = "$script:dataPath\$script:dataFile"

    Write-Verbose -Message 'Confirming valid and current data set...'

    try {
        $pathEval = Test-Path -Path $dataFile -ErrorAction Stop
    }#try
    catch {
        $result = $false
        Write-Error $_
        return $result
    }#catch

    if (-not ($pathEval)) {
        $result = $false
    }#if_TestPath
    else {
        Write-Verbose 'Data file found. Checking date of file...'
        try {
            $fileData = Get-ChildItem -Path $dataFile -ErrorAction Stop
        }
        catch {
            $result = $false
            Write-Error $_
            return $result
        }
        if ($fileData) {
            $creationDate = $fileData.CreationTime
            $now = Get-Date
            if (($now - $creationDate).Days -ge 9) {
                Write-Verbose 'Data file requires refresh.'
                $result = $false
            }
            else {
                Write-Verbose 'Data file verified'
            }
        }
        else {
            Write-Warning 'Unable to retrieve file information for PSGalleryExplorer data set.'
            $result = $false
            return $result
        }
    }

    return $result
}#Confirm-XMLDataSet