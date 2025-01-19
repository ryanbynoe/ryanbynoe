 <#
.SYNOPSIS
    Prevents users from changing installation options by configuring the relevant policy setting.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-19-01
    Last Modified   : 2025-19-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000310

.TESTED ON
    Date(s) Tested  : 2025-19-01
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1

.USAGE
    Run the script to prevent users from changing installation options:
    Example syntax:
    PS C:\> .\WN10-CC-000310.ps1
#>

# Define the registry path, value name, and the desired value.
$RegistryHive = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$ValueName = "EnableUserControl"
$DesiredValue = 0

# Check if the registry key exists; create it if it does not.
if (-not (Test-Path -Path $RegistryHive)) {
    Write-Host "Registry path does not exist. Creating path: $RegistryHive" -ForegroundColor Yellow
    New-Item -Path $RegistryHive -Force | Out-Null
}

# Set the registry value to prevent user control over installs.
Set-ItemProperty -Path $RegistryHive -Name $ValueName -Value $DesiredValue -Type DWord

# Verify the value has been set correctly.
$CurrentValue = Get-ItemProperty -Path $RegistryHive -Name $ValueName | Select-Object -ExpandProperty $ValueName
if ($CurrentValue -eq $DesiredValue) {
    Write-Host "User control over installation options has been successfully disabled." -ForegroundColor Green
} else {
    Write-Host "Failed to set the registry value. Please check permissions or rerun as Administrator." -ForegroundColor Red
}
 
