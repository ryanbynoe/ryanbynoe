 <#
.SYNOPSIS
    Ensures the registry value "AllowDomainPINLogon" exists and is configured correctly to meet security compliance.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-19-01
    Last Modified   : 2025-19-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000370

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\WN10-CC-000370.ps1 
#>

# YOUR CODE GOES HERE# Create or modify the registry path

# Define registry path and value details
$RegistryPath = "HKLM:\Software\Policies\Microsoft\Windows\System"
$ValueName = "AllowDomainPINLogon"
$ExpectedValue = 0  # 0 = Disabled

# Ensure the registry path exists
if (-not (Test-Path $RegistryPath)) {
    Write-Host "Registry path does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -Path $RegistryPath -Force | Out-Null
    Write-Host "Registry path created successfully: $RegistryPath" -ForegroundColor Green
}

# Check and update the registry value
try {
    $CurrentValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $ValueName -ErrorAction SilentlyContinue
} catch {
    Write-Host "Registry value $ValueName does not exist. It will be created." -ForegroundColor Yellow
    $CurrentValue = $null
}

if ($CurrentValue -ne $ExpectedValue) {
    Write-Host "Registry value is missing or incorrect. Updating..." -ForegroundColor Yellow
    Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ExpectedValue -Type DWord
    Write-Host "Registry value updated: $ValueName = $ExpectedValue" -ForegroundColor Green
} else {
    Write-Host "Registry value is already correctly configured: $ValueName = $ExpectedValue" -ForegroundColor Green
}

# Clear Group Policy cache
Write-Host "Clearing Group Policy cache..." -ForegroundColor Cyan
$GroupPolicyPath = "C:\Windows\System32\GroupPolicy"
if (Test-Path $GroupPolicyPath) {
    Remove-Item -Path "$GroupPolicyPath\Machine" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$GroupPolicyPath\User" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Group Policy cache cleared." -ForegroundColor Green
} else {
    Write-Host "Group Policy cache directory not found. Skipping..." -ForegroundColor Yellow
}

# Force Group Policy update
Write-Host "Forcing Group Policy update..." -ForegroundColor Cyan
gpupdate /force | Out-Null
Write-Host "Group Policy update completed." -ForegroundColor Green

# Verify the registry value after update
try {
    $UpdatedValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $ValueName
    if ($UpdatedValue -eq $ExpectedValue) {
        Write-Host "Validation successful: $ValueName is correctly set to $ExpectedValue." -ForegroundColor Green
    } else {
        Write-Host "Validation failed: $ValueName is not correctly configured." -ForegroundColor Red
    }
} catch {
    Write-Host "Validation failed: Unable to retrieve $ValueName. Please check manually." -ForegroundColor Red
}

# Final message
Write-Host "Reboot the system to ensure all changes take effect." -ForegroundColor Yellow 
