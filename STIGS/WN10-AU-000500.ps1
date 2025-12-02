<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Joel Silva
    LinkedIn        : linkedin.com/in/joelsilva12/
    GitHub          : github.com/joelsilvadev
    Date Created    : 12-01-2025
    Last Modified   : 12-01-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

# Check if the application event log already has the configured value
$registroAplicacion = "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\EventLog\\Application"
$valorTamañoMaximo = "MaxSize"

# Define the minimum size in KB (32,768 KB = 32 MB)
$tamañoRequerido = 32768

# Check if the registry key exists
if (Test-Path $registroAplicacion) {
    Write-Host "The registry key for the application events exists. Verifying the maximum size..."
} else {
    Write-Host "The registry key does not exist. Creating the key..."
    # Create the registry key if it doesn't exist
    New-Item -Path "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\EventLog" -Name "Application" -Force
}

# Check if the 'MaxSize' entry already exists in the registry
$valorExistente = Get-ItemProperty -Path $registroAplicacion -Name $valorTamañoMaximo -ErrorAction SilentlyContinue

if ($valorExistente -ne $null) {
    Write-Host "The 'MaxSize' value is already configured. Verifying the current value..."
    
    # Check if the current value is less than the required one
    if ($valorExistente.$valorTamañoMaximo -lt $tamañoRequerido) {
        Write-Host "The current value is less than required. Updating the size..."
        # Update the size to 32 MB
        Set-ItemProperty -Path $registroAplicacion -Name $valorTamañoMaximo -Value $tamañoRequerido
        Write-Host "The size has been successfully updated to $tamañoRequerido KB."
    } else {
        Write-Host "The value is already correctly configured to $tamañoRequerido KB or more."
    }
} else {
    Write-Host "'MaxSize' does not exist. Creating the entry with the required value..."
    # Create the registry entry for the maximum size
    Set-ItemProperty -Path $registroAplicacion -Name $valorTamañoMaximo -Value $tamañoRequerido
    Write-Host "The 'MaxSize' entry has been created with the value of $tamañoRequerido KB."
}

# Verify that the changes have been applied
$valorAplicacion = Get-ItemProperty -Path $registroAplicacion -Name $valorTamañoMaximo
Write-Host "The configured maximum size is: $($valorAplicacion.$valorTamañoMaximo) KB"
