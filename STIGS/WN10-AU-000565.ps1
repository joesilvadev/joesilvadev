<#
.SYNOPSIS
    This PowerShell script configures the policy to audit "Other Logon/Logoff Events" failures.

.NOTES
    Author          : Joel Silva
    LinkedIn        : linkedin.com/in/joelsilva12/
    GitHub          : github.com/joelsilvadev
    Date Created    : 12-02-2025
    Last Modified   : 12-02-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000565

.TESTED ON
    Date(s) Tested  : 
    Tested By       : Joel Silva
    Systems Tested  : Windows 10 Enterprise
    PowerShell Ver. : 

.USAGE
    Example usage:
    PS C:\> .\Configure-AuditOtherLogonLogoffEvents.ps1
    This will configure the "Audit Other Logon/Logoff Events" to "Failure".
#>

# Ensure that the "Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings" is enabled
$forceAuditPolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$forceAuditPolicyName = "AuditPolSubcategoryOverride"

# Check if the policy exists, if not, set it to enabled (1)
$currentAuditPolicy = Get-ItemProperty -Path $forceAuditPolicyPath -Name $forceAuditPolicyName -ErrorAction SilentlyContinue
if ($currentAuditPolicy -eq $null -or $currentAuditPolicy.$forceAuditPolicyName -ne 1) {
    Write-Output "Enabling 'Audit: Force audit policy subcategory settings to override audit policy category settings'."
    Set-ItemProperty -Path $forceAuditPolicyPath -Name $forceAuditPolicyName -Value 1
} else {
    Write-Output "'Audit: Force audit policy subcategory settings' is already enabled."
}

# Configure the "Audit Other Logon/Logoff Events" to Failure
$auditPolicyCategory = "Logon/Logoff"
$auditPolicyName = "Audit Other Logon/Logoff Events"
$auditPolicySetting = "Failure"

# Apply the AuditPol command to configure the audit policy
Write-Output "Configuring audit policy for 'Audit Other Logon/Logoff Events' with 'Failure'."
AuditPol /set /subcategory:"Other Logon/Logoff Events" /failure:enable

# Confirm the change
Write-Output "Audit Policy for 'Audit Other Logon/Logoff Events' is set to 'Failure'."
