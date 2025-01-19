 <#
.SYNOPSIS
    This STIG requirement (WN10-CC-000170) ensures that Microsoft accounts are optional for modern style apps, 
    allowing enterprise credentials to be used instead. This helps maintain control of credentials within the 
    enterprise environment.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-18-01
    Last Modified   : 2025-18-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000170

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\WN10-CC-000170.ps1 
#>


# Verify if running with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Script must run with administrative privileges. Please restart as administrator."
    Exit 1
}

# Define registry parameters
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$name = "MSAOptional"
$value = 1

try {
    # Create registry path if it doesn't exist
    if (-not (Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    # Set registry value
    Set-ItemProperty -Path $registryPath -Name $name -Value $value -Type DWord -Force

    # Verify the change
    $verifyValue = Get-ItemProperty -Path $registryPath -Name $name -ErrorAction Stop
    
    if ($verifyValue.$name -eq $value) {
        Write-Host "STIG Fix successfully applied - Microsoft accounts are now optional for modern style apps" -ForegroundColor Green
        Write-Host "Current Setting: $($verifyValue.$name)"
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
Write-Host "2. Navigate to HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Write-Host "3. Verify 'MSAOptional' is set to '1' (REG_DWORD)"
Write-Host "`nNote: A system restart is recommended for changes to take effect." 
