# Windows Boot Feature Manager

The **Windows Boot Feature Manager** is a PowerShell script designed to enable or disable specific Windows features based on the currently selected boot entry. This tool simplifies the management of features for different boot configurations, ensuring that the right features are active for your selected environment.

## Table of Contents

- [Requirements](#requirements)
- [How to Create Boot Entry within Windows](#how-to-create-boot-entry-within-windows)
- [How the Code Works](#how-the-code-works)
- [Using Task Scheduler](#using-task-scheduler)
- [Log File](#log-file)
- [Usage](#usage)

## Requirements

- Windows PowerShell
- Administrative privileges to run the script
- Windows 10 or later

## How to Create Boot Entry within Windows

To create a new boot entry, follow these steps:

1. Open an elevated Command Prompt or PowerShell.
2. Use the `bcdedit` command to create a new entry. For example:
   ```bash
   bcdedit /copy {current} /d "$New_Boot_Entry"
3. This command copies the current boot entry and creates a new one with the specified name.

## How the Code Works

The script performs the following actions:

1.**Check for Administrative Privileges:**  
  The script checks if it is running with administrative rights. If not, it relaunches itself with elevated privileges.
  ```powershell
  #powershell
  function Test-Admin { ... }
  ```

2.**Log File Initialization:**  
It initializes a log file to track the script's actions.
```powershell
#powershell
Copy code
$logPath = "C:\Scripts\LogFile.log"
```

3.**Get the Current Boot Entry:**  
The script retrieves the currently selected boot entry from the boot manager.
```powershell
#powershell
Copy code
foreach ($boot in $bootmanager) { ... }
```  

4.**Enable or Disable Features:**  
Based on the current boot entry, the script enables or disables the feature.
```powershell
#powershell
Copy code
if ($bootEntry -eq "$New_Boot_Entry") { ... }
elseif ($bootEntry -eq "$Current_Boot_Entry") { ... }
```

## Using Task Scheduler

To ensure that the script runs with the highest priority:

1.Open Task Scheduler.
2.Create a new task and set the following properties:
+ Run with highest privileges.
+ Trigger the task at system startup or on a specific event related to boot entries.
+ Set the action to run your PowerShell script.  

## Log File
The script maintains a log file located at C:\Scripts\LogFile.log. This file records the actions taken by the script, including:
+ Start and completion messages.
+ Status of feature enabling or disabling.
+ Any errors encountered during execution.

## Usage
To use the Windows Boot Feature Manager:

1.Ensure the script is run with administrative privileges.  
2.Execute the script in PowerShell:
```powershell
#powershell
.\YourScriptName.ps1
```
## Example Output
Upon execution, the log file will include entries such as:
```yaml
#yaml
Copy code
2024-07-17 12:00:00 - Script started.
2024-07-17 12:00:01 - Current Boot Loaded : Windows Subsystem for Linux
2024-07-17 12:00:02 - Enabled feature: $feature_name
2024-07-17 12:00:03 - Script completed.
```
