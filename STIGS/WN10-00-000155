 <#
.SYNOPSIS
    Remediates STIG ID: WN10-00-000155 - Windows PowerShell 2.0 Disable

.NOTES
    Author          : Ryan Bynoe
    LinkedIn        : linkedin.com/in/ryanbynoe/
    GitHub          : github.com/ryanbynoe
    Date Created    : 2025-18-01
    Last Modified   : 2025-18-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000155

.TESTED ON
    Date(s) Tested  : Ryan Bynoe
    Tested By       : Ryan Bynoe
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\WN10-00-000155.ps1 
#>

# YOUR CODE GOES HERE# Create or modify the registry path# Check if running as administrator

function Get-PSv2Status {
    $psv2Features = Get-WindowsOptionalFeature -Online | Where-Object FeatureName -like *PowerShellv2*
    return $psv2Features
}

# Function to log results
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('Info','Warning','Error')]
        [string]$Level = 'Info'
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
    
    # You can add file logging here if needed
    # Add-Content -Path "C:\Logs\STIG_Remediation.log" -Value $logMessage
}

# Main execution
try {
    Write-Log "Starting PowerShell 2.0 STIG compliance check..."
    
    # Check current status
    $psv2Status = Get-PSv2Status
    
    # Display current status
    foreach ($feature in $psv2Status) {
        Write-Log "Feature: $($feature.FeatureName) - Current State: $($feature.State)"
    }
    
    # Check if remediation is needed
    $needsRemediation = $psv2Status | Where-Object State -eq 'Enabled'
    
    if ($needsRemediation) {
        Write-Log "PowerShell 2.0 features found enabled. Beginning remediation..." -Level Warning
        
        # Attempt remediation
        Write-Log "Disabling MicrosoftWindowsPowerShellV2Root..."
        $result = Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -NoRestart
        
        # Verify remediation
        $postRemediationStatus = Get-PSv2Status
        $stillEnabled = $postRemediationStatus | Where-Object State -eq 'Enabled'
        
        if ($stillEnabled) {
            Write-Log "Remediation failed. PowerShell 2.0 features are still enabled." -Level Error
            exit 1
        } else {
            Write-Log "Remediation successful. PowerShell 2.0 features are now disabled."
            
            if ($result.RestartNeeded) {
                Write-Log "System restart is required to complete the changes." -Level Warning
            }
        }
    } else {
        Write-Log "No remediation needed. PowerShell 2.0 features are already disabled."
    }
    
} catch {
    Write-Log "An error occurred during execution: $_" -Level Error
    exit 1
} 
