<#
.SYNOPSIS
    This PowerShell script disables Internet Explorer 11 (IE11) as a standalone
    browser on Windows 10 by configuring the corresponding Group Policy registry key
    with the option set to "Never" notify users.

.NOTES
    Author          : Joel Silva
    LinkedIn        : linkedin.com/in/joelsilva12/
    GitHub          : github.com/joelsilvadev
    Date Created    : 12-02-2025
    Last Modified   : 12-02-2025
    Version         : 1.1
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000391

.TESTED ON
    Date(s) Tested  :
    Tested By       : Joel Silva
    Systems Tested  : Windows 10 Enterprise
    PowerShell Ver. :

.USAGE
    Example usage:
    PS C:\> .\Disable-IE11Standalone.ps1
    This will disable Internet Explorer 11 as a standalone browser with the
    notification option set to "Never".
#>

# Define base registry paths for the policy
$regBasePath = "HKLM:\SOFTWARE\Policies\Microsoft"
$ieKeyPath   = Join-Path $regBasePath "Internet Explorer"
$mainKeyPath = Join-Path $ieKeyPath "Main"

# Ensure the required registry keys exist
if (-not (Test-Path $ieKeyPath)) {
    New-Item -Path $ieKeyPath -Force | Out-Null
}

if (-not (Test-Path $mainKeyPath)) {
    New-Item -Path $mainKeyPath -Force | Out-Null
}

# Registry value name and desired configuration
# NotifyDisableIEOptions:
#   0 = Never notify (IE11 disabled as standalone browser, no warning)
#   1 = Always notify
#   2 = Once per user
$regName  = "NotifyDisableIEOptions"
$regValue = 0

Write-Output "Disabling Internet Explorer 11 as a standalone browser (Notify option: Never)."

try {
    # Try to read the current value
    $current = Get-ItemProperty -Path $mainKeyPath -Name $regName -ErrorAction Stop

    if ($current.$regName -ne $regValue) {
        # Update existing registry value
        Set-ItemProperty -Path $mainKeyPath -Name $regName -Value $regValue
        Write-Output "Updated registry value '$regName' to $regValue."
    } else {
        Write-Output "Registry value '$regName' is already set to $regValue (desired state)."
    }
}
catch {
    # Value does not exist – create it as a DWORD
    New-ItemProperty -Path $mainKeyPath -Name $regName -Value $regValue -PropertyType DWord -Force | Out-Null
    Write-Output "Created registry value '$regName' with value $regValue."
}

# Display final value for verification
$final = Get-ItemProperty -Path $mainKeyPath -Name $regName
Write-Output "Final value of '$regName' at '$mainKeyPath': $($final.$regName)"
Write-Output "Internet Explorer 11 should now be disabled as a standalone browser."
