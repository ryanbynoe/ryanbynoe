 <#
.SYNOPSIS
This STIG requirement (WN10-CC-000370) ensures that convenience PIN sign-in is disabled for domain users, 
reducing potential security vulnerabilities in the authentication process.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-18-01
    Last Modified   : 2025-18-01
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


# Verify if running with administrative privileges

# Verify if running with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Script must run with administrative privileges. Please restart as administrator."
    Exit 1
}

# Define registry parameters
$registryPath = "HKLM:\Software\Policies\Microsoft\Windows\System"
$name = "AllowDomainPINLogon"
$value = 0

try {
    # Create registry path if it doesn't exist
    if (-not (Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Created new registry path: $registryPath"
    }

    # Set registry value
    Set-ItemProperty -Path $registryPath -Name $name -Value $value -Type DWord -Force

    # Verify the change
    $verifyValue = Get-ItemProperty -Path $registryPath -Name $name -ErrorAction Stop
    
    if ($verifyValue.$name -eq $value) {
        Write-Host "STIG Fix successfully applied - Convenience PIN sign-in is now disabled" -ForegroundColor Green
        Write-Host "Current Setting: $($verifyValue.$name) (0 = Disabled)"
    } else {
        Write-Host "STIG Fix failed - Current setting is: $($verifyValue.$name)" -ForegroundColor Red
        Exit 1
    }
} catch {
    Write-Error "An error occurred while applying the STIG fix: $_"
    Exit 1
}

# Output validation steps
Write-Host "`nValidation Steps:"
Write-Host "1. Open Registry Editor (regedit.exe)"
Write-Host "2. Navigate to HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System"
Write-Host "3. Verify 'AllowDomainPINLogon' is set to '0' (REG_DWORD)"
Write-Host "`nNote: A system restart is recommended for changes to take effect."

# Additional check for existing PINs
Write-Host "`nAdditional Information:"
Write-Host "To ensure complete security, any existing PINs should be removed manually through Windows Settings > Accounts > Sign-in options." 
