<#
.SYNOPSIS

A script to register the necessary Azure Compute resource providers in a specified Azure subscription.

.DESCRIPTION

A script to register the necessary Azure Compute resource providers in a specified Azure subscription.
The script will do all of the following:

Remove the breaking change warning messages.
Change the current context to the specified subscription.
Register the required Azure resource providers for Containers in the current subscription, if they are not already registered.
Register the required Azure resource providers for Core Networking in the current subscription, if they are not already registered.
Register the required Azure resource providers for Azure Update Manager in the current subscription, if they are not already registered.
Register the required Azure resource providers for Defender for Cloud in the current subscription, if they are not already registered.
Register the required Azure resource providers for Azure Automation in the current subscription, if they are not already registered
Register the required Azure resource providers for Azure Monitor in the current subscription, if they are not already registered.
Register the required Azure resource providers for Azure Policy in the current subscription, if they are not already registered
Register the required Azure resource providers for Azure Key Vault in the current subscription, if they are not already registered

.NOTES

Filename:       Register-Azure-Compute-resource-providers-in-a-specified-subscriptions.ps1
Created:        04/08/2025
Last modified:  04/05/2025
Author:         Wim Matthyssen
Version:        1.0
PowerShell:     Azure PowerShell and Azure Cloud Shell
Requires:       PowerShell Az (v10.4.1)
Action:         Change variables were needed to fit your needs.
Disclaimer:     This script is provided "As Is" with no warranties.

.EXAMPLE

Connect-AzAccount
Get-AzTenant (if not using the default tenant)
Set-AzContext -tenantID "xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxx" (if not using the default tenant)
.\Register-Azure-Compute-resource-providers-in-a-specified-subscription -SubscriptionName <"your Azure subscription name here"> 

-> .\Register-Azure-Compute-resource-providers-in-a-specified-subscription -SubscriptionName sub-prd-myh-compute-01

.LINK

#>

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Parameters

param(
    # $subscriptionName -> Name of the Azure Subscription
    [parameter(Mandatory =$true)][ValidateNotNullOrEmpty()] [string] $subscriptionName
)

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

$providerNameSpaceContainerInstance = "Microsoft.ContainerInstance"
$providerNameSpaceContainerRegistry = "Microsoft.ContainerRegistry"
$providerNameSpaceContainerService = "Microsoft.ContainerService"
$providerNameSpaceManagedIdentity = "Microsoft.ManagedIdentity"
$providerNameSpaceStorage = "Microsoft.Storage"
$providerNameSpaceNetwork = "Microsoft.Network"
$providerNameSpaceInsights = "Microsoft.Insights"
$providerNameSpaceCompute = "Microsoft.Compute" 
$providerNameSpaceHybridCompute = "Microsoft.HybridCompute"
$providerNameSpaceMaintenance = "Microsoft.Maintenance"
$providerNameSpaceSecurity = "Microsoft.Security"
$providerNameSpacePolicyInsights = "Microsoft.PolicyInsights"
$providerNameSpaceAutomation = "Microsoft.Automation"  
$providerNameSpaceOperationalInsights = "Microsoft.OperationalInsights"
$providerNameSpaceWeb = "Microsoft.Web"
$providerNameSpaceSql = "Microsoft.Sql"
$providerNameSpaceGuestConfiguration = "Microsoft.GuestConfiguration"
$providerNameSpaceManagement = "Microsoft.Management"
$providerNameSpaceKeyvault = "Microsoft.KeyVault"

$global:currenttime = Get-Date -Format "dddd MM/dd/yyyy HH:mm"
$foregroundColor1 = "Green"
$foregroundColor2 = "Yellow"
$writeEmptyLine = "`n"
$writeSeperatorSpaces = " - "

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Remove the breaking change warning messages

Set-Item -Path Env:\SuppressAzurePowerShellBreakingChangeWarnings -Value $true | Out-Null
Update-AzConfig -DisplayBreakingChangeWarning $false | Out-Null
$warningPreference = "SilentlyContinue"

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script started

Write-Host ($writeEmptyLine + "# Script started. Without errors, it can take up to 2 minutes to complete" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Change the current context to the specified subscription

$subName = Get-AzSubscription | Where-Object {$_.Name -like $subscriptionName}

Set-AzContext -SubscriptionId $subName.SubscriptionId | Out-Null 

Write-Host ($writeEmptyLine + "# Specified subscription in current tenant selected" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Register the required Azure resource providers for Containers in the current subscription, if they are not already registered

# Register Microsoft.ContainerInstance resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceContainerInstance | Out-Null

# Register Microsoft.ContainerRegistry resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceContainerRegistry  | Out-Null

# Register Microsoft.ContainerService resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceContainerService | Out-Null

# Register Microsoft.ManagedIdentity resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceManagedIdentity | Out-Null

# Register Microsoft.Storage resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceStorage | Out-Null

Write-Host ($writeEmptyLine + "# All required resource providers for Containers are currently registering or have already registered" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Register the required Azure resource providers for Core Networking in the current subscription, if they are not already registered

# Register Microsoft.Network resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceNetwork | Out-Null

# Register Microsoft.Insights resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceInsights | Out-Null

Write-Host ($writeEmptyLine + "# All required resource providers for Core Networking are currently registering or have already registered" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Register the required Azure resource providers for Azure Update Manager in the current subscription, if they are not already registered

# Register Microsoft.Compute resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceCompute  | Out-Null

# Register Microsoft.HybridCompute resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceHybridCompute | Out-Null

# Register Microsoft.Maintenance resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceMaintenance | Out-Null

Write-Host ($writeEmptyLine + "# All required resource providers for AUM are currently registering or have already registered" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Register the required Azure resource providers for Defender for Cloud in the current subscription, if they are not already registered

# Register Microsoft.Security resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceSecurity | Out-Null

# Register Microsoft.PolicyInsights resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpacePolicyInsights | Out-Null

Write-Host ($writeEmptyLine + "# All required resource providers for Defender for Cloud are currently registering or have already registered" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Register the required Azure resource providers for Azure Automation in the current subscription, if they are not already registered

# Register Microsoft.Automation resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceAutomation | Out-Null

Write-Host ($writeEmptyLine + "# All required resource providers for Azure Automation are currently registering or have already registered" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Register the required Azure resource providers for Azure Monitor in the current subscription, if they are not already registered

# Register Microsoft.OperationalInsights resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceOperationalInsights | Out-Null

# Register Microsoft.Web resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceWeb | Out-Null

# Register Microsoft.Sql resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceSql | Out-Null

Write-Host ($writeEmptyLine + "# All required resource providers for Azure Monitor are currently registering or have already registered" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Register the required Azure resource providers for Azure Policy in the current subscription, if they are not already registered

# Register Microsoft.GuestConfiguration resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceGuestConfiguration | Out-Null

# Register Microsoft.Management resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceManagement | Out-Null

Write-Host ($writeEmptyLine + "# All required resource providers for Azure Policy are currently registering or have already registered" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Register the required Azure resource providers for Azure Key Vault in the current subscription, if they are not already registered

# Register Microsoft.KeyVault resource provider
Register-AzResourceProvider -ProviderNamespace $providerNameSpaceKeyvault | Out-Null

Write-Host ($writeEmptyLine + "# All required resource providers for Azure Key Vault are currently registering or have already registered" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script completed

Write-Host ($writeEmptyLine + "# Script completed" + $writeSeperatorSpaces + $global:currenttime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
