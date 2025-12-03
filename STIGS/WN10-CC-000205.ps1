# PowerShell Script to Configure Windows Telemetry to Security Level

This PowerShell script configures the Windows Telemetry setting to "Security" (which is the lowest level of data collection) in order to meet the STIG requirements for Windows 10.

## Script

```powershell
<#
.SYNOPSIS
    This PowerShell script configures the Windows Telemetry setting to the Security level (0x00000000).

.NOTES
    Author          : Joel Silva
    LinkedIn        : linkedin.com/in/joelsilva12/
    GitHub          : github.com/joelsilvadev
    Date Created    : 12-02-2025
    Last Modified   : 12-02-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000205

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Example usage:
    PS C:\> .\Configure-TelemetrySecurity.ps1
    This will configure the "AllowTelemetry" registry key to 0x00000000 (Security).
#>

# Define the registry path for telemetry settings
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"

# Check if the registry path exists, if not, create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

# Define the value name and set the desired value for "Security"
$regName = "AllowTelemetry"
$regValue = 0

# Check if the registry value already exists
$currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

if ($currentValue -eq $null) {
    # If the value doesn't exist, create it with the desired value
    New-ItemProperty -Path $regPath -Name $regName -Value $regValue -PropertyType DWord -Force
    Write-Output "The registry value '$regName' has been successfully configured to $regValue (Security)."
} else {
    # If the value exists, check if it matches the desired value
    if ($currentValue.$regName -ne $regValue) {
        # If the value doesn't match, update it
        Set-ItemProperty -Path $regPath -Name $regName -Value $regValue
        Write-Output "The registry value '$regName' has been updated to $regValue (Security)."
    } else {
        Write-Output "The registry value '$regName' is already configured correctly to $regValue (Security)."
    }
}

# Confirm the final value of the registry setting
$finalValue = Get-ItemProperty -Path $regPath -Name $regName
Write-Output "Final value of '$regName': $($finalValue.$regName)"
