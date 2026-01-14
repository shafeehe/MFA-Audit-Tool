# AWS IAM Security Audit PowerShell Module

AWS IAM Security Audit Tool is a professionally structured PowerShell module designed to audit AWS IAM security posture using read-only AWS APIs.

This is an installable PowerShell module that provides 'cmdlets' to audit IAM users and root users MFA compliance, analyse users-activity and detect inactive users along with credential analysis and collect overall security audit report in your AWS account.This project is actively developed with version control and documentation maintained in GitHub.

This project is part of my Cloud & DevOps learning journey — focused on building real automation tools instead of standalone scripts. The tool is structured as a reusable PowerShell module, similar to how enterprise automation tools are packaged and deployed.

The function is built, debugged and tested on the PowerShell ISE. Stay tuned for the latest releases and upgrades!

---

## Key Features✅


-1️⃣IAM MFA Compliance Audit:

  -List IAM Users and identify each IAM user with MFA enabled or disabled in your AWS Account.
  
  -Export the report to convenient formats such as .csv or .html .

-2️⃣Inactive IAM User Detection with Summary Statistics:

  -List all IAM Users and then detect IAM users with no console or access key activity beyond a configurable threshold(default: 90 days), ie: inactive users. 
  -Generate summary statistics: get the aggregrate count of total, inactive and active users in  your AWS Account. (Summary objects is for Report generation & "Group-Object" is for analytics & computing)
  
  -Export the report to convenient formats such as *.csv*/ *.html*/ *.json* .

  -Uses AWS IAM Credential Report.

  -Supports filtering inactive users only using switches ( " ...... -OnlyInactive " )

## Other Features✅: 

- Safety Guardrails:
  -AWS account confirmation before audit execution & prevents accidental execution against unintended accounts.

- Fully Automation Compatible Output(objects):
  -The script ( .ps1) is machine-safe(Boolean) and Human-readable(strings) and therefore automation and pipeline friendly

- "Get-Help" Self Documentation Guide.
  
- Object-based output suitable for filtering and export:
  -Outputs structured audit data (using "[PSCustomObject]@ {}...") rather than just printing the output.

- Supports pipe-lines( '|') to tools such as:
  - `Export-Csv`....
  - `Format-Table`...
  - `Where-Object` / 'Sort-Object' .....
    
- Designed with a professional PowerShell module structure:
  - '.psm1' --> Root File, '.psd1' --> module manifest, '.ps1' --> My Function File
  
----

## 🧩 Cmdlet Examples

-1️⃣IAM MFA Compliance Audit:

  - Get-MFAReport                                                     --> returns IAM users and their MFA status.
  - Get-MFAReport | Export-Csv filename.csv -NoTypeInformation        --> export as csv file
  - Get-MFAReport | Format-Table -Autosize                            --> auto-adjust the displaying table
  - Get-MFAReport | Where-Object { $_.MFA_Status -eq "Disabled" }     --> search for users with MFA disabled.
  - .....

-2️⃣Inactive IAM User Detection with Summary Statistics:

  - Get-InactiveIAMUsers                                               --> returns IAM user activity and summary count of users
  - Get-InactiveIAMUsers -Days 120                                     --> returns users that are inactive for last 120 days (you sets the threshold days)
  - Get-InactiveIAMUsers -OnlyInactive                                 --> lists inactive users only (switch parameter )
  - Get-InactiveIAMUsers -IncludeSummary                               --> include summary counts of users
  - Get-InactiveIAMUsers | Export-Csv filename.csv -NoTypeInformation  --> exports as csv file
  

-Exporting syntaxes:
  "....... |Export-Csv" , "........ |ConvertTo-Html", "......... |ConvertTo-Json", "........ |Export-Clixml"


   

##  Prerequisites

- Windows PowerShell / PowerShell 7
- AWS PowerShell Tools (`AWS.Tools.IAM`)
- AWS credentials configured for your AWS Account(`aws configure` or `Set-AWSCredential`)

---


## ⚠️Note ⚠️ ##

*This tool is designed to run with IAM roles like "SecurityAudit"
and should not be executed using Administrator or Root credentials.*

-Your AWS account *MUST* have atleast the minimum required *PERMISSIONS* to run this tool:

  -iam:ListUsers.
  
  -iam:ListMFADevices.
  
  -iam:ListAccessKeys.
  
  -iam:GenerateCredentialReport.


---

##  Installation Methods


## Option 1 — Install from GitHub (recommended)

Run these commands in PowerShell:

- "cd $env:USERPROFILE\Documents\WindowsPowerShell\Modules"
- "git clone https://github.com/<your-username>/MFA-Audit-Tool.git MFAAudit"



- Then import the module: "Import-Module MFAAudit"
- Confirm it works: "Get-MFAReport"

PowerShell will also auto-load your MFA-Audit-Module in future sessions.

---

## Option 2 — Manual Install (without Git)

-Download the repo as ZIP from GitHub and extract it to:
"Documents\WindowsPowerShell\Modules\MFAAudit"

---
This is a learning-driven project — feedback, suggestions, and collaboration are welcome.
---

##👤Author
---
Mohammed Shafeehe
Cloud / DevOps Engineering Aspirant
