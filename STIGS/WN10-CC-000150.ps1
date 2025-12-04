<#
.SYNOPSIS
    This PowerShell script configures the setting to require a password when a computer wakes from sleep (plugged in).

.NOTES
    Author          : Joel Silva
    LinkedIn        : linkedin.com/in/joelsilva12/
    GitHub          : github.com/joelsilvadev
    Date Created    : 12-04-2025
    Last Modified   : 12-04-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000150

.TESTED ON
    Date(s) Tested  :
    Tested By       : Joel Silva
    Systems Tested  : Windows 10 Enterprise
    PowerShell Ver. :

.USAGE
    Example usage:
    PS C:\> .\RequirePasswordOnResume.ps1
    This will configure the system to require a password when the computer wakes up from sleep (plugged in).
#>

# Define the registry path for the Power Settings related to wake-up behavior
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51"

# Check if the registry path exists, if not, create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Define the registry value name and the value to set
$regName  = "ACSettingIndex"
$regValue = 1  # 1 to require password on resume when plugged in

Write-Output "Configuring system to require a password when the computer wakes from sleep (plugged in)."

# Set the registry value to require password on wake-up (plugged in)
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
Write-Output "Password requirement on resume from sleep (plugged in) is now configured."
