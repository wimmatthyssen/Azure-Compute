<#
.SYNOPSIS

A script used to list and export VM SKUs in a specified region that supports a specified minimum number of NICs.

.DESCRIPTION

A script used to list and export VM SKUs in a specified region that supports a specified minimum number of NICs.
The script will do all of the following:

Remove the breaking change warning messages.
Import the Az.Compute module if it is not already imported.
Validate if the provided region is a valid Azure region, otherwise exit the script.
Create the C:\Temp folder if it does not exist.
List VM SKUs with the specified value or more network interfaces in the specified region.
Export the filtered SKUs to a CSV file without including type information.
Open the CSV file.

.NOTES

Filename:       List-and-Export-VM-SKUs-in-region-with-minimum-number-of-NICs.ps1
Created:        23/05/2024
Last modified:  23/05/2024
Author:         Wim Matthyssen
Version:        1.0
PowerShell:     Azure PowerShell and Azure Cloud Shell
Requires:       PowerShell Az (v10.4.1) 
Action:         Change variables where needed to fit your needs. 
Disclaimer:     This script is provided "as is" with no warranties.

.EXAMPLE

Connect-AzAccount
Get-AzTenant (if not using the default tenant)
Set-AzContext -tenantID "xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxx" (if not using the default tenant)
.\List-and-Export-VM-SKUs-in-region-with-minimum-number-of-NICs.ps1 -region <"Azure region here>" -minNics <"minimum number of NICs here>"

-> .\List-and-Export-VM-SKUs-in-region-with-minimum-number-of-NICs.ps1 -region westeurope -minNics 3

.LINK

#>

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Parameters

param(
    # $region -> Name of Azure region
    [parameter(Mandatory =$true)][ValidateNotNullOrEmpty()] [string] $region,
    # $minNics -> Minimum number of network interfaces
    [parameter(Mandatory =$true)] [ValidateNotNullOrEmpty()] [ValidateRange(1,8)] [int] $minNics
)

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

$driveLetter = "C:"
$tempFolderName = "Temp"
$tempFolderPath = Join-Path -Path $driveLetter -ChildPath $tempFolderName
$itemType = "Directory"
$csvFileName = "VM_SKUs.csv"

$global:currenttime= Set-PSBreakpoint -Variable currenttime -Mode Read -Action {$global:currenttime= Get-Date -UFormat "%A %m/%d/%Y %R"}
$foregroundColor1 = "Green"
$foregroundColor2 = "Yellow"
$writeEmptyLine = "`n"
$writeSeperatorSpaces = " - "

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Remove the breaking change warning messages
 
Set-Item -Path Env:\SuppressAzurePowerShellBreakingChangeWarnings -Value $true | Out-Null
Update-AzConfig -DisplayBreakingChangeWarning $false | Out-Null
$warningPreference = "SilentlyContinue"

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script started

Write-Host ($writeEmptyLine + "# Script started. Without errors, it can take up to 1 minutes to complete" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Import the Az.Compute module if it is not already imported

if (-not (Get-Module -Name Az.Compute)) {
    Import-Module Az.Compute
}

Write-Host ($writeEmptyLine + "# Az.compute module available" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Validate if the provided region is a valid Azure region, otherwise exit the script

# Define a list of valid Azure regions
$validRegions = @(
    "eastus", "eastus2", "centralus", "northcentralus", "southcentralus", 
    "westus", "westus2", "westus3", "canadacentral", "canadaeast", 
    "brazilsouth", "brazilsoutheast", "northeurope", "westeurope", 
    "francecentral", "francesouth", "uksouth", "ukwest", 
    "germanynorth", "germanywestcentral", "norwayeast", "norwaywest", 
    "switzerlandnorth", "switzerlandwest", "italynorth", "italynorth2", 
    "eastasia", "southeastasia", "australiaeast", "australiasoutheast", 
    "australiacentral", "australiacentral2", "chinaeast", "chinanorth", 
    "chinaeast2", "chinanorth2", "centralindia", "southindia", "westindia", 
    "japaneast", "japanwest", "koreacentral", "koreasouth", 
    "southafricanorth", "southafricawest", "uaenorth", "uaecentral", 
    "israelcentral", "saudiarabiawest", "saudiarabiaeast"
)

# Check if the provided region is valid
if ($region -notin $validRegions) {
    Write-Host ($writeEmptyLine + "# The provided region $region is not a valid Azure region. Please provide a valid Azure region." + $writeSeperatorSpaces + $currentTime)`
    -foregroundcolor $foregroundColor2 $writeEmptyLine
    exit
}

Write-Host ($writeEmptyLine + "# Specified region $region is a valid Azure region" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create the C:\Temp folder if not exists

If(!(Test-Path $tempFolderPath))
{
    New-Item -Path $driveLetter -Name $folderName -ItemType $itemType -Force | Out-Null
}

Write-Host ($writeEmptyLine + "# $tempFolderName folder available under the C: drive" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## List VM SKUs with the specified value or more network interfaces in the specified region

# Get all compute resource SKUs
$allSkus = Get-AzComputeResourceSku 

# Filter SKUs based on location, resource type, and network interface capabilities
$filteredSkus = $allSkus | Where-Object {
    $_.Locations.Contains($region) -and 
    $_.ResourceType -eq "virtualMachines" -and 
    $_.Capabilities.Where({
        $_.Name -eq "MaxNetworkInterfaces" -and 
        [int]$_.Value -ge $minNics
    })
}

# Create custom objects for each filtered SKU
$customObjects = $filteredSkus | ForEach-Object {
    $maxNics = $_.Capabilities | 
               Where-Object {$_.Name -eq "MaxNetworkInterfaces"} | 
               Select-Object -ExpandProperty Value

    # Structure the data in the CSV file with the required columns Name, Tier, Size, and MaxNetworkInterfaces
    [PSCustomObject]@{
        'Name' = $_.Name
        'Tier' = $_.Tier
        'Size' = $_.Size
        'MaxNetworkInterfaces' = $maxNics
    }
}

# Export the filtered SKUs to a CSV file without including type information
$customObjects | Export-Csv -Path C:\Temp\VM_SKUs.csv -NoTypeInformation

Write-Host ($writeEmptyLine + "# CSV file $csvFileName created" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Open the CSV file

# Combine the directory path and the filename into a full path
$fullPath = Join-Path -Path $tempFolderPath -ChildPath $csvFileName

Invoke-Item $fullPath

Write-Host ($writeEmptyLine + "# CSV file $csvFileName opened" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script completed

Write-Host ($writeEmptyLine + "# Script completed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
