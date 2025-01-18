 <#
.SYNOPSIS
    This STIG requirement (WN10-AC-000020) ensures that users cannot reuse their previous 24 passwords, 
    reducing the risk of password recycling and enhancing system security. This setting must be configured 
    in the Local Security Policy.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-18-01
    Last Modified   : 2025-18-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000020

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\WN10-AC-000020.ps1 
#>

# YOUR CODE GOES HERE# Create or modify the registry path# Check if running as administrator

# Verify if running with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Script must run with administrative privileges. Please restart as administrator."
    Exit 1
}

try {
    # Set password history to 24
    $result = net accounts /uniquepw:24
    
    # Verify the change
    $currentSetting = (net accounts | Select-String "Length of password history maintained").ToString().Split(":")[1].Trim()
    
    if ($currentSetting -eq "24") {
        Write-Host "STIG Fix successfully applied - Password history is now set to 24" -ForegroundColor Green
        Write-Host "Current Setting: $currentSetting passwords remembered"
    } else {
        Write-Host "STIG Fix failed - Current setting is: $currentSetting" -ForegroundColor Red
        Exit 1
    }
} catch {
    Write-Error "An error occurred while applying the STIG fix: $_"
    Exit 1
}

# Output validation steps
Write-Host "`nValidation Steps:"
Write-Host "1. Open Local Security Policy (secpol.msc)"
Write-Host "2. Navigate to Security Settings > Account Policies > Password Policy"
Write-Host "3. Verify 'Enforce password history' is set to '24 passwords remembered'" 
