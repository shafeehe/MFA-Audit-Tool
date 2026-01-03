# AWS IAM MFA Audit PowerShell Module


A PowerShell module that audits IAM users in an AWS account and reports whether MFA is enabled or disabled for each user.

This project is part of my Cloud & DevOps learning journey — focused on building real automation tools instead of standalone scripts. The tool is structured as a reusable PowerShell module, similar to how enterprise automation tools are packaged and deployed.

The function is built and well tested on the PowerShell ISE and stay tuned for the further upgrades!

---

## Features

- Lists all IAM users in an AWS account
- Checks whether MFA is enabled for each user
- Outputs structured objects (PowerShell-native format)
- Export the report to convenient formats such as .csv and .html .
- Supports piping ( '|') to tools like:
  - `Export-Csv`
  - `Format-Table`
  - `Where-Object`
- Designed with a professional module structure:
  - '.psm1' --> Root File, '.psd1' --> module manifest, '.ps1' --> My Function File
  
----

## 🧩 Cmdlet Included

 - "Get-MFAReport" --> Returns IAM users and their MFA status.
 - "Get-MFAReport | Export-Csv filename.csv -NoTypeInformation " --> export as csv file
 - "Get-MFAReport | Format-Table -Autosize " --> Auto-adjust the displaying table
 - ...



##  Prerequisites

- Windows PowerShell / PowerShell 7
- AWS PowerShell Tools (`AWS.Tools.IAM`)
- AWS credentials configured (`aws configure` or `Set-AWSCredential`)

---

##  Installation Methods

## Option 1 — Install from GitHub (recommended)

Run these commands in PowerShell:

- "cd $env:USERPROFILE\Documents\WindowsPowerShell\Modules"
- "git clone https://github.com/<your-username>/MFA-Audit-Tool.git MFAAudit"

---


- Then import the module: "Import-Module MFAAudit"
- Confirm it works: "Get-MFAReport"

PowerShell will also auto-load your MFA-Audit-Module in future sessions.


## Option 2 — Manual Install (without Git)

Download the repo as ZIP from GitHub and extract it to:
"Documents\WindowsPowerShell\Modules\MFAAudit"

---
This is a learning-driven project — feedback, suggestions, and collaboration are welcome.


##👤Author

Mohammed Shafeehe
Cloud / DevOps Engineering Aspirant
