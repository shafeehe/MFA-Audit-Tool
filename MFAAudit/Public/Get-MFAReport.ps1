<#
.SYNOPSIS
Generates a report of IAM Users and their MFA status.

.DESCRIPTION
This cmdlet checks all the IAM users in the AWS account and returns their MFA status as Enabled or Disabled . 

.EXAMPLE
Get-MFAReport

.NOTES
Author: Mohammed Shafeehe
Module: AWS IAM MFA Audit Tool
#>
#Guardrail for Multi-account Access: confirm before running the audit
try {

    $identity = Get-STSCallerIdentity
    $AccountID = $identity.Account

    $alias = (Get-IAMAccountAlias -ErrorAction SilentlyContinue)
    if ($alias) { $AccountName = $alias }
    else { $AccountName = "No Alias ($AccountID)" }

    Write-Host "`nYou are about run MFA Audit on:" -ForegroundColor Yellow
    Write-Host "the AWS Account: $AccountName"
    Write-Host "Account ID: $AccountID`n"

    $confirm = Read-Host "type YES to continue"
    if ($confirm -ne "YES") {
        Write-Host "The operation is cancelled." -ForegroundColor Red 
        return }
    }
    
catch {
        Write-Host "Unable to verify AWS Account. Check credentials or AWS Configure. " -ForegroundColor Red
        return
      }

function Get-MFAReport {
    
    [CmdletBinding()]
    param() 

    $iamUsers = Get-IAMUserList

    foreach ($user in $iamUsers) {
        $mfaDevices = Get-IAMMFADevice -UserName $user.UserName
        $mfaStatus  = if ($mfaDevices.Count -gt 0) { "Enabled" } else { "Disabled" }

        [PSCustomObject]@{
            UserName   = $user.UserName
            MFA_Status = $mfaStatus
        }
    }
}
