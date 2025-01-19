 <#
.SYNOPSIS
    Ensures that User Account Control (UAC) properly prompts administrators for consent on the secure desktop, enhancing security by requiring explicit authorization for privileged actions.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-18-01
    Last Modified   : 2025-18-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000250

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\WN10-AU-000250.ps1  
#>

# YOUR CODE GOES HERE# Create or modify the registry path# Check if running as administrator

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    Exit 1
}

try {
    # Define registry path and value
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $name = "ConsentPromptBehaviorAdmin"
    $value = 2

    # Check if registry path exists, if not create it
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    # Set registry value
    Set-ItemProperty -Path $registryPath -Name $name -Value $value -Type DWord -Force

    # Verify the change
    $verifyValue = Get-ItemProperty -Path $registryPath -Name $name
    if ($verifyValue.$name -eq $value) {
        Write-Host "STIG fix successfully applied. ConsentPromptBehaviorAdmin is now set to $value" -ForegroundColor Green
        Write-Host "Please restart the system for changes to take effect" -ForegroundColor Yellow
    } else {
        Write-Host "Failed to verify registry change" -ForegroundColor Red
    }
} catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    Exit 1
} 
