<#
.SYNOPSIS
    Disables the password manager function in the Microsoft Edge browser to enhance security.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-19-01
    Last Modified   : 2025-19-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000245

.TESTED ON
    Date(s) Tested  : 2025-19-01
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1

.USAGE
    Run the script to disable the password manager function in Microsoft Edge:
    Example syntax:
    PS C:\> .\WN10-CC-000245.ps1
#>

# Define the registry path, value name, and the desired value.
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main"
$ValueName = "FormSuggest Passwords"
$DesiredValue = "no"  # Disable password manager

# Check if the registry key exists; create it if it does not.
if (-not (Test-Path -Path $RegistryPath)) {
    Write-Host "Registry path does not exist. Creating path: $RegistryPath" -ForegroundColor Yellow
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the registry value to disable the password manager.
Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $DesiredValue -Type String

# Verify the value has been set correctly.
$CurrentValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName | Select-Object -ExpandProperty $ValueName
if ($CurrentValue -eq $DesiredValue) {
    Write-Host "Password manager in Microsoft Edge has been successfully disabled." -ForegroundColor Green
} else {
    Write-Host "Failed to set the registry value. Please check permissions or rerun as Administrator." -ForegroundColor Red
}
