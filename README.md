# AWS IAM Security Audit PowerShell Module
---------------------------------------------------

- AWS IAM Security Audit Tool is a professionally structured PowerShell module designed to audit AWS IAM security posture using read-only AWS APIs.

- This is an installable PowerShell module that provides 'cmdlets' to audit IAM users and root users MFA compliance, analyse users-activity and detect inactive users along with credential analysis and collect overall security audit report in your AWS account.This project is actively developed version control and documentation maintained in GitHub.

- This project is part of my Cloud & DevOps learning journey — focused on building real automation tools instead of standalone scripts. The tool is structured as a reusable PowerShell module, similar to how enterprise automation tools are packaged and deployed.


______________________________________________________________________________________________________

> ## Key Features✅


1️⃣IAM MFA Compliance Audit:
---------------------------------
  - ✅Cmdlet: Get-InactiveIAMUsers

<img width="1040" height="65" alt="image" src="https://github.com/user-attachments/assets/b799e8b2-fba6-46fc-be73-f6d250eceed8" />


  - List IAM Users and identify each IAM user with MFA enabled or disabled in your AWS Account.
    
  - Root Account MFA is excluded (security best practice).

  - Uses AWS IAM Credential Report.
  
  ------------------------------------------------------------------------------

2️⃣Inactive IAM User Detection with Summary Statistics:
---------------------------------------------------------
  - ✅Cmdlet: Get-InactiveIAMUsers

<img width="913" height="43" alt="image" src="https://github.com/user-attachments/assets/bc7a06b0-90f5-498e-ad6d-9dab7c6fc10c" />

  
  - List all IAM Users and then detect IAM users with no console or access key activity beyond a configurable threshold(default: 90 days), ie: inactive users.

  - Set custom days threshold for identifying inactive users ( default: 90days).
  
  - Generate summary statistics: get the aggregrate count of total, inactive and active users in  your AWS Account. (Summary objects is for Report generation & "Group-Object" is for analytics & computing)

  - Supports filtering inactive users only using switches ( " ...... -OnlyInactive " ).

  - Uses AWS IAM Credential Report.
  ------------------------------------------------------------------------------

3️⃣ Access Key Security Audit and identify credentials hygiene: 
-----------------------------------------------------------------
  -✅Cmdlet: Get-AccessKeyAgeReport

<img width="730" height="49" alt="image" src="https://github.com/user-attachments/assets/b448c3bd-c671-4f33-86b7-b7d9bc5dcad1" />

  - Evaluates AWS IAM access key security posture and identifies credential hygiene risks based on AWS best practices.

  - What It Checks:

    - Access Keys Older Than 90 Days ( Rotation Policy Violation: identifies which violates the AWS recommended Key-Rotation Policies, thus enforcing security best practices.)
    - Never-Used Access Keys
    - Multiple Active Access Keys per User
    - Console Password + Active Access Key Exposure
  
  - Each IAM user is assigned a consolidated RiskLevel:

      - LOW – No detected issues
      - MEDIUM – Hygiene or exposure concern
      - HIGH – Rotation policy violation (> threshold)
  ------------------------------------------------------------------------------

4️⃣ AWS Root Account Security Audit Report:
-------------------------------------------------------
  -✅Cmdlet: Get-RootAccountSecurity

<img width="877" height="55" alt="image" src="https://github.com/user-attachments/assets/75b074c6-eb88-4c8d-b0fb-a41f1eca5f2e" />

  
  >> Use the root account only for tasks that require it, and only when absolutely necessary.
  
  - Audits the AWS Root Account for critical security risks using the IAM-Credentials-Report

  - Checks performed:
    - Root MFA status
    - Presence of active root access keys
    - Recent root console login activity
    - Overall root account risk classification
  - Risk levels returned:
    - LOW – No security issues detected
    - HIGH – Risky root usage detected (e.g., recent console login)
    - CRITICAL – Severe misconfiguration (e.g., MFA disabled or active access keys)
   
_________________________________________________________________
> ## Other Features✅: 

- Safety Guardrails:
  - AWS account confirmation before audit execution & prevents accidental execution against unintended accounts.

- Fully Automation Compatible Output(objects):
  - The script ( .ps1) is machine-safe(Boolean) and Human-readable(strings) and therefore automation and pipeline friendly

- "Get-Help" Self Documentation Guide.
  
- Object-based output suitable for filtering and export:
  - Outputs structured audit data (using "[PSCustomObject]@ {}...") rather than just printing the output.
 
- Export the report to convenient formats such as *.csv*/ *.html*/ *.json* ...

- Supports pipe-lines( '|') to tools such as:
  - `Export-Csv`....
  - `Format-Table`...
  - `Where-Object` / 'Sort-Object' .....
    
- Designed with a professional PowerShell module structure:
  - '.psm1' --> Root File, '.psd1' --> module manifest, '.ps1' --> My Function File
  
----

> ## Basic Architecture

<img width="768" height="431" alt="image" src="https://github.com/user-attachments/assets/de42d858-1df8-4105-8b94-a322da16f773" />


----
> ## 🧩 Cmdlet Examples

-1️⃣IAM MFA Compliance Audit:

  - Get-MFAReport                                                     --> returns IAM users and their MFA status.
  - Get-MFAReport | Export-Csv filename.csv -NoTypeInformation        --> export as csv file
  - Get-MFAReport | Format-Table -Autosize                            --> auto-adjust the displaying table
  - Get-MFAReport | Where-Object { $_.MFA_Status -eq "Disabled" }     --> search for users with MFA disabled.
  - .....

-2️⃣Inactive IAM User Detection with Summary Statistics:

  - Get-InactiveIAMUsers                                               --> returns IAM user activity and summary count of users
  - Get-InactiveIAMUsers -Days 120                                     --> returns users that are inactive for last 120 days (you sets the threshold days as you wish)
  - Get-InactiveIAMUsers -OnlyInactive                                 --> lists inactive users only (switch parameter )
  - Get-InactiveIAMUsers -IncludeSummary                               --> include summary counts of users

-3️⃣ Detect Access-Keys that violate AWS Key-Rotation Policies:

  - Get-AccessKeyAgeReport
  - Get-AccessKeyAgeReport | -OnlyRisky
  - Get-AccessKeyAgeReport | Export-Csv AccessKeyAudit.csv -NoTypeInformation


-4️⃣ AWS Root Account Security Audit Report:

  - Get-RootAccountSecurity

------------------------------------------------------------


- Exporting syntaxes:  
  "....... |Export-Csv" , "........ |ConvertTo-Html", "......... |ConvertTo-Json", "........ |Export-Clixml"
______________________________________________________________
   

> ## 🛠 Prerequisites

- Windows PowerShell / PowerShell 7
- AWS PowerShell Tools (`AWS.Tools.IAM`)
- AWS credentials configured for your AWS Account(`aws configure` or `Set-AWSCredential`)

------------------------------------------------------------


> ## ⚠️Note 

*This tool is designed to run with IAM roles like "SecurityAudit"
and should not be executed using Administrator or Root credentials.*

-Your AWS account *MUST* have atleast the minimum required *PERMISSIONS* to run this tool:

  - iam:ListUsers.
  
  - iam:ListMFADevices.
  
  - iam:ListAccessKeys.
  
  - iam:GenerateCredentialReport.



> ##  📥Installation Methods


###  Option 1 — Install from GitHub (recommended) 

Run these commands in PowerShell:

- "cd $env:USERPROFILE\Documents\WindowsPowerShell\Modules"
- "git clone https://github.com/<your-username>/MFA-Audit-Tool.git MFAAudit"



- Then import the module: "Import-Module MFAAudit"
- Confirm it works: "Get-MFAReport"

PowerShell will also auto-load your MFA-Audit-Module in future sessions.

---

### Option 2 — Manual Install (without Git)

- Download the repo as ZIP from GitHub and extract it to:
  - "Documents\WindowsPowerShell\Modules\MFAAudit"

___________________________________________________________________________________________

This is a learning-driven project — feedback, suggestions, and collaboration are welcome.
---
__________________________________________________________________________________

#👤Author
-------------------------------------------------------------------------------------------

## MOHAMMED SHAFEEHE
Cloud / DevOps Engineer | Oracle Certified Architect Associate | ECE Graduate

_______________________________________________________________________________________
