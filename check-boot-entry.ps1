# Function to check if the script is running with administrative privileges
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check for administrative privileges and re-launch the script if necessary
if (-not (Test-Admin)) {
    # Re-launch the script with elevated privileges
    $arguments = "& '" + $myInvocation.MyCommand.Definition + "'"
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    exit
}
# Path to the log file
$logPath = "C:\Scripts\LogFile.log"

Clear-Content -Path $logPath

# Ensure the log directory exists
if (-not (Test-Path "C:\Scripts")) {
    New-Item -ItemType Directory -Path "C:\Scripts"
}

# Function to log messages to a log file
function Log-Message {
    param (
        [string]$Message
    )
    Add-Content -Path $logPath -Value "$(Get-Date) - $Message"
}

Log-Message "Script started."

# Get the current boot entry description
$bootmanager = @(
    "Windows 10",
    "Windows Subsystem for Linux"
)

foreach ($boot in $bootmanager) {

$bcddetails=bcdedit /enum | Select-String -Pattern "$boot" -Context 3,0
if ($bcddetails -match "{current}") {
$bootEntry= $boot
Log-Message "Current Boot Loaded : $bootEntry"
break
}
}

try{
if ($bootEntry -eq "Windows Subsystem for Linux") {

   # Check if Virtual Machine Platform is enabled
   $feature = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

   if ($feature.State -eq 'Disabled') {
   	Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
   	Log-Message "Enabled feature: VirtualMachinePlatform"
	Log-Message "Script completed."
	shutdown.exe /r /t 0 /f
}}
 elseif ($bootEntry -eq "Windows 10") {

    # Check if Virtual Machine Platform is enabled
    $feature = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

    if ($feature.State -eq 'Enabled') {
    	Disable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
    	Log-Message "Disabled feature: VirtualMachinePlatform"
	Log-Message "Script completed."
	shutdown.exe /r /t 0 /f
}}}
 catch {
        Log-Message "Error processing feature : "
    }

