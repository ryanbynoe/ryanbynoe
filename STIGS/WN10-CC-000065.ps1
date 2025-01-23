 <#
.SYNOPSIS
    Disables Wi-Fi Sense by configuring the AutoConnectAllowedOEM registry value.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-01-22
    Last Modified   : 2025-01-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000065

.TESTED ON
    Date(s) Tested  : 2025-01-22
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10 v1803 and above
    PowerShell Ver. : 5.1

.USAGE
    Example syntax:
    PS C:\> .\WN10-CC-000065.ps1
#>

# Ensure the registry key exists and set the value to disable Wi-Fi Sense
try {
    $RegistryPath = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
    $ValueName = "AutoConnectAllowedOEM"
    $DesiredValue = 0

    # Check if the registry key exists
    if (-not (Test-Path -Path $RegistryPath)) {
        Write-Host "Registry path does not exist. Creating it..." -ForegroundColor Yellow
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Set the registry value
    Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $DesiredValue -Force

    Write-Host "Wi-Fi Sense has been successfully disabled." -ForegroundColor Green
} catch {
    Write-Error "An error occurred while disabling Wi-Fi Sense: $_"
}
 
