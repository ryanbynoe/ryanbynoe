 <#
.SYNOPSIS
    Disables the display of slide shows on the lock screen to prevent sensitive information from being exposed.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-19-01
    Last Modified   : 2025-19-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000010

.TESTED ON
    Date(s) Tested  : 2025-19-01
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1

.USAGE
    Run the script to disable the lock screen slideshow:
    Example syntax:
    PS C:\> .\WN10-CC-000010.ps1
#>

# Define the registry path, value name, and the desired value.
$RegistryHive = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$ValueName = "NoLockScreenSlideshow"
$DesiredValue = 1

# Check if the registry key exists; create it if it does not.
if (-not (Test-Path -Path $RegistryHive)) {
    Write-Host "Registry path does not exist. Creating path: $RegistryHive" -ForegroundColor Yellow
    New-Item -Path $RegistryHive -Force | Out-Null
}

# Set the registry value to disable the lock screen slideshow.
Set-ItemProperty -Path $RegistryHive -Name $ValueName -Value $DesiredValue -Type DWord

# Verify the value has been set correctly.
$CurrentValue = Get-ItemProperty -Path $RegistryHive -Name $ValueName | Select-Object -ExpandProperty $ValueName
if ($CurrentValue -eq $DesiredValue) {
    Write-Host "Lock screen slideshow has been successfully disabled." -ForegroundColor Green
} else {
    Write-Host "Failed to set the registry value. Please check permissions or rerun as Administrator." -ForegroundColor Red
}
 
