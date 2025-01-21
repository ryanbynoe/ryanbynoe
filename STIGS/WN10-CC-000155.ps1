 <#
.SYNOPSIS
    Disables Solicited Remote Assistance to prevent unauthorized access to the system.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-01-21
    Last Modified   : 2025-01-21
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000155

.TESTED ON
    Date(s) Tested  : 2025-01-21
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10 Pro, Windows Server 2019
    PowerShell Ver. : 5.1

.USAGE
    Save this script as DisableSolicitedRemoteAssistance.ps1 and run it with administrator privileges.
    Example syntax:
    PS C:\DisableSolicitedRemoteAssistance.ps1
#>

# Define the registry path and value
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$ValueName = "fAllowToGetHelp"
$DesiredValue = 0

# Check if the registry path exists, create it if necessary
if (-not (Test-Path $RegistryPath)) {
    Write-Host "Registry path does not exist. Creating: $RegistryPath" -ForegroundColor Yellow
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the registry value to disable solicited remote assistance
try {
    Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $DesiredValue -Force
    Write-Host "Successfully disabled Solicited Remote Assistance." -ForegroundColor Green
} catch {
    Write-Host "Failed to update the registry. Error: $_" -ForegroundColor Red
}

# Verify the change
$CurrentValue = (Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName
if ($CurrentValue -eq $DesiredValue) {
    Write-Host "Verification passed: Solicited Remote Assistance is disabled." -ForegroundColor Green
} else {
    Write-Host "Verification failed: Solicited Remote Assistance is not properly configured." -ForegroundColor Red
}
 
