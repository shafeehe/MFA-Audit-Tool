# AWS IAM Security Audit PowerShell Module
---------------------------------------------------

- IAMSecurityAudit is a structured PowerShell module designed to audit AWS IAM security posture using read-only AWS APIs.

- It provides modular, automation-ready cmdlets to evaluate:
  - MFA compliance
  - IAM user inactivity
  - Access key security hygiene
  - Root account security posture

- This project focuses on building real-world security automation aligned with AWS best practices.

- The tool is structured as a reusable PowerShell module, similar to how enterprise automation tools are packaged and deployed.
______________________________________________________________________________________________________

> ## Core Security Features (v1.0.0)✅


1️⃣IAM MFA Compliance Audit:
---------------------------------
  - ✅Cmdlet: Get-InactiveIAMUsers

<img width="1040" height="65" alt="image" src="https://github.com/user-attachments/assets/b799e8b2-fba6-46fc-be73-f6d250eceed8" />


  - List IAM Users with MFA enabled or disabled in your AWS Account.
    
  - Root Account MFA is excluded (security best practice).

  - Uses AWS IAM Credential Report.
  
  ------------------------------------------------------------------------------

2️⃣Inactive IAM User Detection with Summary Statistics:
---------------------------------------------------------
  - ✅Cmdlet: Get-InactiveIAMUsers

<img width="913" height="43" alt="image" src="https://github.com/user-attachments/assets/bc7a06b0-90f5-498e-ad6d-9dab7c6fc10c" />

  
  - Detect inactive IAM users beyond a configurable threshold(default: 90 days).

  - Evaluates Console/Access Key activity ( default: 90days).
  
  - Generate summary statistics: get the aggregrate count of total, inactive and active users.
    
  - Supports filtering inactive users using switch -OnlyInactive .
  
  - Supports summary view using -IncludeSummary .
  -----------------------------------------------------------------------------

3️⃣ Access Key Security Audit and identify credentials hygiene: 
-----------------------------------------------------------------
  -✅Cmdlet: Get-AccessKeyAgeReport

<img width="730" height="49" alt="image" src="https://github.com/user-attachments/assets/b448c3bd-c671-4f33-86b7-b7d9bc5dcad1" />

  - Evaluates AWS IAM access key security posture and identifies exposure risks based on AWS best practices.

  - What It Checks:

    - Access Keys Older Than 90 Days ( AWS Key Rotation Policy Violation)
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


  
  > Use the root account only for tasks that require it, and only when absolutely necessary.
  
  - Audits the AWS Root Account for critical security risks using the IAM-Credentials-Report
  
  - Checks root account for:
    - Root MFA status
    - Active root access keys
    - Recent root console login activity
    - Overall root account risk classification
    
  - Risk levels returned:
    - LOW – No security issues detected
    - HIGH – Risky root usage detected (e.g., recent console login)
    - CRITICAL – Severe misconfiguration (e.g., MFA disabled or active access keys)
   
_________________________________________________________________
> ## Architecture Highlights✅: 

- Safety Guardrails:
  - AWS account confirmation before audit execution & prevents accidental execution against unintended accounts.

- Fully Automation Compatible Output(objects):
  - Object-based output (PSCustomObject) – pipeline & automation compatible
  
- Risk classification engine

- "Get-Help" Self Documentation Guide.
  
- Export the report to convenient formats such as *.csv*/ *.html*/ *.json* ...

- Supports pipe-lines( '|') to tools such as:
  - `Export-Csv`..., `Format-Table`... `Where-Object...`, `Sort-Object` .....
    
- Professional PowerShell modular structure:
  - '.psm1' --> Root File, '.psd1' --> module manifest, '.ps1' --> My Function File
  
----

> ## Basic Architecture

<img width="768" height="431" alt="image" src="https://github.com/user-attachments/assets/de42d858-1df8-4105-8b94-a322da16f773" />


----
> ## 🧩 Cmdlet Examples

-1️⃣IAM MFA Compliance Audit:

  - `Get-MFAReport`                                                     --> returns IAM users and their MFA status.
  - `Get-MFAReport | Export-Csv filename.csv -NoTypeInformation`        --> export as csv file
  - `Get-MFAReport | Format-Table -Autosize`                            --> auto-adjust the displaying table
  - `Get-MFAReport | Where-Object { $_.MFA_Status -eq "Disabled" }`     --> search for users with MFA disabled.


-2️⃣Inactive IAM User Detection with Summary Statistics:

  - `Get-InactiveIAMUsers`                                               --> returns IAM user activity and summary count of users
  - `Get-InactiveIAMUsers -Days 120`                                     --> returns users that are inactive for last 120 days (you sets the threshold days as you wish)
  - `Get-InactiveIAMUsers -OnlyInactive`                                 --> lists inactive users only (switch parameter )
  - `Get-InactiveIAMUsers -IncludeSummary`                               --> include summary counts of users


-3️⃣ Detect Access-Keys that violate AWS Key-Rotation Policies:

  - `Get-AccessKeyAgeReport`
  - `Get-AccessKeyAgeReport | -OnlyRisky`


-4️⃣ AWS Root Account Security Audit Report:

  - `Get-RootAccountSecurity`

------------------------------------------------------------


- ## Exporting syntaxes:  
  `....... |Export-Csv` , `........ |ConvertTo-Html`, `......... |ConvertTo-Json`, `...... |Export-Clixml`
______________________________________________________________
   

> ## 🛠 Prerequisites

- Windows PowerShell 5.1+ / PowerShell 7+
- AWS PowerShell Tools (`AWS.Tools.IdentityManagement`)
- AWS credentials configured for your AWS Account(`aws configure` or `Set-AWSCredential`)

------------------------------------------------------------


> ## ⚠️Note 

>> *This tool is designed to run with IAM roles like "SecurityAudit"
and should not be executed using Administrator or Root credentials.*

- Your AWS account *MUST* have atleast the minimum required *PERMISSIONS* to run this tool:

  - iam:ListUsers.
  - iam:ListMFADevices.
  - iam:ListAccessKeys.
  - iam:GenerateCredentialReport.

____________________________________________________________________________

> ##  📥Installation Methods


- ###  Option 1 — Install from GitHub (recommended) 

Run these commands in PowerShell:

- `cd $env:USERPROFILE\Documents\WindowsPowerShell\Modules`
- `git clone https://github.com/<your-username>/MFA-Audit-Tool.git IAMSecurityAudit`
- Then import the module: `Import-Module IAMSecurityAudit`
- Confirm it works: `Get-MFAReport`

PowerShell will also auto-load your MFA-Audit-Module in future sessions.

---

- ### Option 2 — Manual Install (without Git)

- Download the repo as ZIP from GitHub and extract to:
  - "Documents\WindowsPowerShell\Modules\IAMSecurityAudit"

___________________________________________________________________________________________


📋 License
----------------------------

- MIT License
___________________________________________________________________________________________

👤Author
-------------------------------------------------------------------------------------------
## Mohammed Shafeehe
> Cloud / DevOps Engineer | 
> Oracle Certified OCI Architect Associate

___________________________________________________________________________________________
This is a learning-driven project. Feedback, suggestions, and collaboration are welcome.
---
___________________________________________________________________________________________

_______________________________________________________________________________________
