<#
.SYNOPSIS
    Configures Windows Defender SmartScreen settings in Microsoft Edge to comply with STIG ID WN10-CC-000235.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-01-19
    Last Modified   : 2025-01-19
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000235

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1+

.USAGE
    Run this script with administrative privileges.
    Example syntax:
    PS C:\WN10-CC-000235.ps1
#>

# Ensure the script is run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator." -ForegroundColor Red
    exit 1
}

# Define registry path and settings for Windows Defender SmartScreen in Microsoft Edge
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter"
$RegName = "PreventOverrideAppRepUnknown"
$RegValue = 1

# Check if the registry path exists; create it if not
if (-not (Test-Path $RegPath)) {
    Write-Host "Registry path does not exist. Creating: $RegPath" -ForegroundColor Yellow
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the required registry value to ensure compliance
try {
    Set-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -Force
    Write-Host "Registry value set successfully. STIG compliance achieved." -ForegroundColor Green
} catch {
    Write-Host "Failed to set registry value. Error: $_" -ForegroundColor Red
}

# Confirm the settings
$currentValue = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegName
if ($currentValue -eq $RegValue) {
    Write-Host "Verification successful. The system is compliant with STIG ID WN10-CC-000235." -ForegroundColor Green
} else {
    Write-Host "Verification failed. Please review the settings manually." -ForegroundColor Red
}
