 <#
.SYNOPSIS
    Configures the Early Launch Antimalware - Boot-Start Driver Initialization policy to enforce "Good, unknown and bad but critical" drivers (preventing "bad" drivers).

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-19-01
    Last Modified   : 2025-19-01
    Version         : 1.2
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000085

.TESTED ON
    Date(s) Tested  : 2025-19-01
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1

.USAGE
    Run the script to configure Early Launch Antimalware policy:
    Example syntax:
    PS C:\> .\WN10-CC-000085.ps1
#>

# Define the registry path, value name, and the desired value.
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Policies\EarlyLaunch"
$ValueName = "DriverLoadPolicy"
$DesiredValue = 3  # Good, unknown, and bad but critical

# Check if the registry key exists; create it if it does not.
if (-not (Test-Path -Path $RegistryPath)) {
    Write-Host "Registry path does not exist. Creating path: $RegistryPath" -ForegroundColor Yellow
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the registry value to enforce the desired policy.
Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $DesiredValue -Type DWord

# Verify the value has been set correctly.
$CurrentValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName | Select-Object -ExpandProperty $ValueName
if ($CurrentValue -eq $DesiredValue) {
    Write-Host "Early Launch Antimalware policy has been successfully configured." -ForegroundColor Green
} else {
    Write-Host "Failed to set the registry value. Please check permissions or rerun as Administrator." -ForegroundColor Red
} 
