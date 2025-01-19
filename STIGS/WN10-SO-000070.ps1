 <#
.SYNOPSIS
    Configures the machine inactivity limit to 15 minutes to lock the system with the screensaver.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-19-01
    Last Modified   : 2025-19-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000070

.TESTED ON
    Date(s) Tested  : 2025-19-01
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1

.USAGE
    Run the script to configure the machine inactivity limit:
    Example syntax:
    PS C:\> .\WN10-SO-000070.ps1
#>

# Define the registry path, value name, and the desired value.
$RegistryHive = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$ValueName = "InactivityTimeoutSecs"
$DesiredValue = 900

# Check if the registry key exists; create it if it does not.
if (-not (Test-Path -Path $RegistryHive)) {
    Write-Host "Registry path does not exist. Creating path: $RegistryHive" -ForegroundColor Yellow
    New-Item -Path $RegistryHive -Force | Out-Null
}

# Set the registry value to configure the inactivity timeout.
Set-ItemProperty -Path $RegistryHive -Name $ValueName -Value $DesiredValue -Type DWord

# Verify the value has been set correctly.
$CurrentValue = Get-ItemProperty -Path $RegistryHive -Name $ValueName | Select-Object -ExpandProperty $ValueName
if ($CurrentValue -eq $DesiredValue) {
    Write-Host "Machine inactivity limit has been successfully configured to 15 minutes." -ForegroundColor Green
} else {
    Write-Host "Failed to set the registry value. Please check permissions or rerun as Administrator." -ForegroundColor Red
}
 
