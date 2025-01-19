 <#
.SYNOPSIS
    Enables the "Turn on PowerShell Script Block Logging" policy.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-19-01
    Last Modified   : 2025-19-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000326

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\WN10-CC-000326.ps1 
#>

# YOUR CODE GOES HERE# Create or modify the registry path
# Define the registry paths and key
$ComputerConfigPath = "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$UserConfigPath = "HKCU:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$ValueName = "EnableScriptBlockLogging"
$ValueData = 1  # 1 = Enabled

# Function to configure the policy
Function Set-ScriptBlockLoggingPolicy {
    param (
        [string]$RegistryPath
    )
    if (-not (Test-Path $RegistryPath)) {
        Write-Host "Creating registry path: $RegistryPath" -ForegroundColor Yellow
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData -Type DWord
    Write-Host "Policy set to Enabled at: $RegistryPath" -ForegroundColor Green
}

# Apply policy under Computer Configuration
Write-Host "Configuring 'Turn on PowerShell Script Block Logging' under Computer Configuration..." -ForegroundColor Cyan
Set-ScriptBlockLoggingPolicy -RegistryPath $ComputerConfigPath

# Apply policy under User Configuration
Write-Host "Configuring 'Turn on PowerShell Script Block Logging' under User Configuration..." -ForegroundColor Cyan
Set-ScriptBlockLoggingPolicy -RegistryPath $UserConfigPath

# Verify the changes
Function Verify-Policy {
    param (
        [string]$RegistryPath
    )
    $CurrentValue = (Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName
    if ($CurrentValue -eq $ValueData) {
        Write-Host "Policy successfully enabled at: $RegistryPath (Value: $CurrentValue)" -ForegroundColor Green
    } else {
        Write-Host "Policy not configured at: $RegistryPath (Value: $CurrentValue)" -ForegroundColor Red
    }
}

# Verify Computer Configuration
Verify-Policy -RegistryPath $ComputerConfigPath

# Verify User Configuration
Verify-Policy -RegistryPath $UserConfigPath

# Suggest a reboot
Write-Host "Reboot the system to ensure the policy is fully applied." -ForegroundColor Yellow 
