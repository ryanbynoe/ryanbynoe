# Threat Hunt Report (Unauthorized Data Exfiltration)

- [Scenario Creation](https://github.com/ryanbynoe/ryanbynoe/blob/main/threat-hunts/data-exfiltration/google-transfer-scenario.md)
- 
## Detection of Unauthorized File Share Use on Workstation: `ryan-lab-threat`

### Example Scenario:
Management suspects employees are using unauthorized cloud storage (e.g., Dropbox, Google Drive) to upload sensitive data. Network logs have shown significant outbound traffic to cloud storage IP ranges during off-hours.

---

### High-Level Firefox-Related IoC Discovery Plan:
- Check `DeviceNetworkEvents` for cloud storage services.
- Check `DeviceProcessEvents` for Firefox and Google Drive.
- Check `DeviceNetworkEvents` for suspicious network connections.

---

### Steps Taken

#### 1. Network Events Analysis
Searched the `DeviceNetworkEvents` table for any indications of cloud storage service interactions and identified several instances involving the remote URL `.googleapis.com` around the timestamp `2025-01-22T01:53:32.9737726Z`. Initiating process command lines included `updater.exe` and `googledriveFS.exe`.

**Query to Locate Events:**
```kql
DeviceNetworkEvents
| where DeviceName == "ryan-lab-threat"
| where RemoteUrl has_any ("dropbox.com", "drive.google.com", "googleapis.com")
| where RemotePort in (443, 80)
| project Timestamp, DeviceName, RemoteIP, RemoteUrl, RemotePort, InitiatingProcessCommandLine, InitiatingProcessAccountName
| where Timestamp >= datetime(2025-01-22T01:53:32.9737726Z)
```
<img width="1212" alt="image" src="/threat-hunts/data-exfiltration/assets/1.jpg">

#### 2. File Transfer Analysis
Searched the `DeviceFileEvents` table for any suspicious file transfers involving the `.csv` file extension, which is a common data format. Identified `two` company files transferred to a `Google Drive` location.

**Query to Locate Events:**
```kql
DeviceFileEvents
| where DeviceName == "ryan-lab-threat"
| where FileName contains ".csv"
| project Timestamp, DeviceName, FileName, PreviousFileName, FolderPath, ActionType, InitiatingProcessAccountName, InitiatingProcessCommandLine
| order by Timestamp desc
```
<img width="1212" alt="image" src="/threat-hunts/data-exfiltration/assets/2.png">

#### 3. File Transfer Analysis
Searched the `DeviceProcessEvents` table for interactions between applications around the timestamp `2025-01-22T01:53:32.9737726Z`. Observed interaction between `googledrivefs.exe` and `explorer.exe` on `Jan 21, 2025, 8:55:46 PM`, immediately preceding the file transfers.

**Query to Locate Events:**
```kql
DeviceProcessEvents
| where DeviceName == "ryan-lab-threat"
| where FileName has_any ("googledrivefs.exe", "googledrive.exe", "drive")
| where Timestamp >= datetime(2025-01-22T01:53:32.9737726Z)
| project Timestamp, DeviceName, AccountName, FileName, ProcessCommandLine, InitiatingProcessFileName
| order by Timestamp desc
```
<img width="1212" alt="image" src="/threat-hunts/data-exfiltration/assets/3.png">

### Chronological Events

1.  **Google Drive Cloud Storage Access**  
    **Timestamp:** Jan 21, 2025, 8:53:32 PM  
    User `ryan` interacted with `googleapis.com`. This could indicate the download or synchronization of Google Drive services.
    
2.  **Unauthorized File Transfer**  
    **Timestamp:** Jan 21, 2025, 8:56:17 PM  
    Two files—`5951_EmployeeRecords.csv` and `8859_CompanyFinancials.csv`—were created in the folder path `G:\My Drive\`, signifying a file transfer to Google Drive.

### Summary

This investigation focused on detecting potential unauthorized use of cloud storage services, specifically identifying interactions with Google Drive and associated file transfers. Management concerns regarding sensitive data exfiltration during off-hours were validated through analysis of `DeviceNetworkEvents`, `DeviceFileEvents`, and `DeviceProcessEvents` tables.

### Response Taken

Temporarily restricted access to Google Drive from the `ryan-lab-threat` workstation and initiated a review to identify if additional sensitive files were transferred. Plans to implement stricter policies and enhance data loss prevention measures are currently under discussion.

