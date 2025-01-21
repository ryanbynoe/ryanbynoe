 <#
.SYNOPSIS
    Configures the system to prevent IP source routing.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-01-21
    Last Modified   : 2025-01-21
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000025

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1

.USAGE
    Run the script with administrative privileges.
    Example:
    PS C:\> .\WN10-CC-000025.ps1
#>

# Ensure the script runs with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as an Administrator! Exiting."
    exit 1
}

# Define registry path, value name, and desired value
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$ValueName = "DisableIPSourceRouting"
$DesiredValue = 2

# Check if the registry key exists
if (-not (Test-Path $RegistryPath)) {
    Write-Error "The registry path $RegistryPath does not exist. Exiting."
    exit 1
}

# Set the registry value
try {
    Write-Host "Configuring IP source routing protection level..." -ForegroundColor Green
    New-ItemProperty -Path $RegistryPath -Name $ValueName -Value $DesiredValue -PropertyType DWORD -Force | Out-Null
    Write-Host "Registry value '$ValueName' set to '$DesiredValue' at path '$RegistryPath'." -ForegroundColor Green
} catch {
    Write-Error "Failed to configure the registry value. Error: $_"
    exit 1
}

# Verify the change
$CurrentValue = (Get-ItemProperty -Path $RegistryPath -Name $ValueName).$ValueName
if ($CurrentValue -eq $DesiredValue) {
    Write-Host "Compliance achieved. IP source routing is disabled." -ForegroundColor Green
} else {
    Write-Error "Compliance not achieved. The registry value does not match the desired configuration."
    exit 1
}
 
