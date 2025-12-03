<#
.SYNOPSIS
    This PowerShell script disables the Windows Game Recording and Broadcasting feature
    by configuring the corresponding registry setting for "AllowGameDVR".

.NOTES
    Author          : Joel Silva
    LinkedIn        : linkedin.com/in/joelsilva12/
    GitHub          : github.com/joelsilvadev
    Date Created    : 12-03-2025
    Last Modified   : 12-03-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000252

.TESTED ON
    Date(s) Tested  :
    Tested By       : Joel Silva
    Systems Tested  : Windows 10 Enterprise
    PowerShell Ver. :

.USAGE
    Example usage:
    PS C:\> .\Disable-GameDVR.ps1
    This will disable the Windows Game Recording and Broadcasting feature by setting
    the "AllowGameDVR" registry value to "0".
#>

# Define the registry path where the Game DVR setting is stored
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"

# Check if the registry path exists, if not, create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Define the registry value and the value to set
$regName  = "AllowGameDVR"
$regValue = 0  # 0 to disable Game DVR

Write-Output "Disabling Windows Game Recording and Broadcasting (Game DVR)."

# Set the registry value to disable Game DVR
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
Write-Output "Windows Game Recording and Broadcasting (Game DVR) should now be disabled."
