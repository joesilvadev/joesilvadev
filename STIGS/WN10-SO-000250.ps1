<#
.SYNOPSIS
    This PowerShell script configures the User Account Control (UAC) setting to prompt administrators for consent on the secure desktop.

.NOTES
    Author          : Joel Silva
    LinkedIn        : linkedin.com/in/joelsilva12/
    GitHub          : github.com/joelsilvadev
    Date Created    : 12-04-2025
    Last Modified   : 12-04-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000250

.TESTED ON
    Date(s) Tested  :
    Tested By       : Joel Silva
    Systems Tested  : Windows 10 Enterprise
    PowerShell Ver. :

.USAGE
    Example usage:
    PS C:\> .\Configure-UACConsentPromptSecureDesktop.ps1
    This will configure UAC to prompt administrators for consent on the secure desktop.
#>

# Define the registry path for UAC settings
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# Check if the registry path exists, if not, create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Define the registry value name and the value to set
$regName  = "ConsentPromptBehaviorAdmin"
$regValue = 2  # 2 to prompt for consent on the secure desktop

Write-Output "Configuring UAC to prompt administrators for consent on the secure desktop."

# Set the registry value to prompt for consent on the secure desktop
try {
    # Try to read the current value
    $current = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop

    if ($current.$regName -ne $regValue) {
        # Update existing registry value
        Set-ItemProperty -Path $regPath -Name $regName -Value $regValue
        Write-Output "Updated registry value '$regName' to $regValue."
    } else {
        Write-Output "Registry value '$regName' is already set to $regValue (desired state)."
    }
}
catch {
    # Value does not exist – create it as a DWORD
    New-ItemProperty -Path $regPath -Name $regName -Value $regValue -PropertyType DWord -Force | Out-Null
    Write-Output "Created registry value '$regName' with value $regValue."
}

# Display final value for verification
$final = Get-ItemProperty -Path $regPath -Name $regName
Write-Output "Final value of '$regName' at '$regPath': $($final.$regName)"
Write-Output "UAC is now configured to prompt administrators for consent on the secure desktop."
