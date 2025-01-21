 <#
.SYNOPSIS
    Fixes the "Always install with elevated privileges" policy to prevent standard user accounts from gaining elevated privileges during application installations.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-01-20
    Last Modified   : 2025-01-20
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000315

.TESTED ON
    Date(s) Tested  : 2025-01-20
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10 (Pro, Enterprise)
    PowerShell Ver. : 5.1

.USAGE
    Run this script as an administrator to apply the necessary registry changes.
    Example syntax:
    PS C:\WN10-CC-000315.ps1 
#>

# Script begins here

# Define registry hive, path, value name, and desired value
$RegHive = "HKLM:\"
$RegPath = "SOFTWARE\Policies\Microsoft\Windows\Installer"
$ValueName = "AlwaysInstallElevated"
$DesiredValue = 0

# Ensure the registry path exists
if (-not (Test-Path "$RegHive$RegPath")) {
    Write-Host "Registry path does not exist. Creating path: $RegPath" -ForegroundColor Yellow
    New-Item -Path "$RegHive$RegPath" -Force | Out-Null
}

# Set the registry value
try {
    Set-ItemProperty -Path "$RegHive$RegPath" -Name $ValueName -Value $DesiredValue -Type DWord
    Write-Host "Successfully set $ValueName to $DesiredValue in $RegPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to set registry value: $_" -ForegroundColor Red
}

# Verify the registry value
$CurrentValue = (Get-ItemProperty -Path "$RegHive$RegPath" -Name $ValueName).$ValueName
if ($CurrentValue -eq $DesiredValue) {
    Write-Host "Verification successful: $ValueName is correctly set to $DesiredValue" -ForegroundColor Green
} else {
    Write-Host "Verification failed: $ValueName is not set correctly. Current value: $CurrentValue" -ForegroundColor Red
}
 
