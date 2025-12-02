<#
.SYNOPSIS
    This PowerShell script ensures that the registry key for the power settings DCSettingIndex is set to the required value of 1.

.NOTES
    Author          : Joel Silva
    LinkedIn        : linkedin.com/in/joelsilva12/
    GitHub          : github.com/joelsilvadev
    Date Created    : 12-01-2025
    Last Modified   : 12-01-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000145

.TESTED ON
    Date(s) Tested  : 12-01-2025
    Tested By       : Joel Silva
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1 or later

.USAGE
    Example syntax:
    PS C:\> .\Set-DCSettingIndex.ps1 
#>

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa515f1"
$valueName = "DCSettingIndex"
$valueData = 1  # Expected value 1 as per the requirement

# Check if the registry path exists, if not create it
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist. Creating the path..."
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings" -Name "0e796bdb-100d-47d6-a2d5-f7d2daa515f1" -Force
}

# Set the DCSettingIndex value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type DWord

# Output success message
Write-Host "The registry value '$valueName' has been set to '$valueData' at '$registryPath'."
