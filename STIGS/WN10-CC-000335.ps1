<#
.SYNOPSIS
    This PowerShell script configures the Windows Remote Management (WinRM) client to disallow unencrypted traffic.

.NOTES
    Author          : Joel Silva
    LinkedIn        : linkedin.com/in/joelsilva12/
    GitHub          : github.com/joelsilvadev
    Date Created    : 12-04-2025
    Last Modified   : 12-04-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000335

.TESTED ON
    Date(s) Tested  :
    Tested By       : Joel Silva
    Systems Tested  : Windows 10 Enterprise
    PowerShell Ver. :

.USAGE
    Example usage:
    PS C:\> .\Disable-UnencryptedTrafficWinRM.ps1
    This will configure WinRM client to disallow unencrypted traffic.
#>

# Define the registry path for WinRM client settings
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"

# Check if the registry path exists, if not, create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Define the registry value name and the value to set
$regName  = "AllowUnencryptedTraffic"
$regValue = 0  # 0 to disallow unencrypted traffic

Write-Output "Configuring WinRM client to disallow unencrypted traffic."

# Set the registry value to disallow unencrypted traffic
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
Write-Output "WinRM client is now configured to disallow unencrypted traffic."
