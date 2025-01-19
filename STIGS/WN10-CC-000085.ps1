 <#
.SYNOPSIS
This STIG requirement (WN10-CC-000085) ensures that Early Launch Antimalware (ELAM) properly controls boot-start 
driver initialization, preventing potentially malicious drivers from loading during the boot process.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-18-01
    Last Modified   : 2025-18-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000085

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\WN10-CC-000085.ps1 
#>


# Verify if running with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Script must run with administrative privileges. Please restart as administrator."
    Exit 1
}

# Define registry parameters
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Policies\EarlyLaunch"
$name = "DriverLoadPolicy"
$value = 3  # 3 = Good, unknown and bad but critical

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
        Write-Host "STIG Fix successfully applied - ELAM Boot-Start Driver Initialization Policy is now set to 'Good, unknown and bad but critical'" -ForegroundColor Green
        Write-Host "Current Setting: $($verifyValue.$name)"
        
        # Display the meaning of the current value
        $valueMeaning = switch ($verifyValue.$name) {
            8 {"Good only"}
            1 {"Good and unknown"}
            3 {"Good, unknown and bad but critical"}
            7 {"All (including bad) - This would be a finding"}
            default {"Unknown setting"}
        }
        Write-Host "Setting interpretation: $valueMeaning"
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
Write-Host "2. Navigate to HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Policies\EarlyLaunch"
Write-Host "3. Verify 'DriverLoadPolicy' is set to '3' (REG_DWORD)"
Write-Host "4. Verify value interpretation: Good, unknown and bad but critical"
Write-Host "`nNote: A system restart is recommended for changes to take effect." 
