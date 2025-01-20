<#
.SYNOPSIS
    Configures the Security event log size to 1024000 KB or greater to prevent logs from filling up quickly.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-19-01
    Last Modified   : 2025-19-01
    Version         : 1.5
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000505

.TESTED ON
    Date(s) Tested  : 2025-19-01
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1

.USAGE
    Run the script to set the Security event log size to 1024000 KB or greater:
    Example syntax:
    PS C:\> .\WN10-AU-000505.ps1
#>

# Define the registry path, value name, and the desired value.
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
$ValueName = "MaxSize"
$DesiredValue = 1024000  # Set log size to 1024000 KB

# Check if the registry key exists; create it if it does not.
if (-not (Test-Path -Path $RegistryPath)) {
    Write-Host "Registry path does not exist. Creating path: $RegistryPath" -ForegroundColor Yellow
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the registry value to configure the maximum log size.
Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $DesiredValue -Type DWord

# Verify the value has been set correctly.
$CurrentValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName | Select-Object -ExpandProperty $ValueName
if ($CurrentValue -ge $DesiredValue) {
    Write-Host "Security event log size has been successfully configured to $DesiredValue KB or greater." -ForegroundColor Green
} else {
    Write-Host "Failed to set the registry value. Please check permissions or rerun as Administrator." -ForegroundColor Red
}
