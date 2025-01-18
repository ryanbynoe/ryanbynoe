 <#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-18-01
    Last Modified   : 2025-18-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\WN10-AU-000500.ps1 
#>

# YOUR CODE GOES HERE# Create or modify the registry path
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$name = "MaxSize"
$value = 0x00008000

# Create the registry key path if it doesn't exist
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $name -Value $value -Type DWord 
