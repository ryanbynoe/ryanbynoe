<#
.SYNOPSIS
    Renames the built-in guest account to comply with STIG ID WN10-SO-000025.

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-01-19
    Last Modified   : 2025-01-19
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000025

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1+

.USAGE
    Run this script with administrative privileges.
    Example syntax:
    PS C:\WN10-SO-000025.ps1
#>

# Ensure the script is run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator." -ForegroundColor Red
    exit 1
}

# Define the new name for the Guest account
$NewGuestName = "NewGuest"

# Get the SID for the Guest account
$GuestSID = (Get-WmiObject -Class Win32_UserAccount -Filter "Name = 'Guest'" | Select-Object -ExpandProperty SID)

if (-not $GuestSID) {
    Write-Host "Guest account not found on this system." -ForegroundColor Red
    exit 1
}

# Use the SID to rename the Guest account
try {
    Rename-LocalUser -SID $GuestSID -NewName $NewGuestName
    Write-Host "Guest account successfully renamed to: $NewGuestName" -ForegroundColor Green
} catch {
    Write-Host "Failed to rename the Guest account. Error: $_" -ForegroundColor Red
    exit 1
}

# Verify the change
$RenamedAccount = Get-WmiObject -Class Win32_UserAccount | Where-Object { $_.SID -eq $GuestSID }
if ($RenamedAccount.Name -eq $NewGuestName) {
    Write-Host "Verification successful. The Guest account has been renamed to: $NewGuestName" -ForegroundColor Green
} else {
    Write-Host "Verification failed. Please check the Guest account manually." -ForegroundColor Red
}
