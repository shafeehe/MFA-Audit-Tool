# AWS IAM MFA Audit PowerShell Module


A PowerShell module that audits IAM users in an AWS account and reports whether MFA is enabled or disabled for each user.

This project is part of my Cloud & DevOps learning journey — focused on building real automation tools instead of standalone scripts. The tool is structured as a reusable PowerShell module, similar to how enterprise automation tools are packaged and deployed.

---

## Features

- Lists all IAM users in an AWS account
- Checks whether MFA is enabled for each user
- Outputs structured objects (PowerShell-native format)
- Supports piping ( '|') to tools like:
  - `Export-Csv`
  - `Format-Table`
  - `Where-Object`
- Designed with a professional module structure:
  - '.psm1' --> Root File, '.psd1' --> module manifest, '.ps1' --> My Function File
  
----

## 🧩 Cmdlet Included

 - "Get-MFAReport" --> Returns IAM users and their MFA status.

Example output:

