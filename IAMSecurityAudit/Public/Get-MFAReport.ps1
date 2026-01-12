# Guardrail: Confirm AWS Account before running audit
try {
    $identity = Get-STSCallerIdentity
    $accountId = $identity.Account

    $alias = (Get-IAMAccountAlias -ErrorAction SilentlyContinue)
    if ($alias) { $accountName = $alias }
    else { $accountName = "No Alias ($accountId)" }

    Write-Host "`nYou are about to run MFA Audit on:" -ForegroundColor Yellow
    Write-Host "AWS Account Name: $accountName"
    Write-Host "Account ID:       $accountId`n"

    $confirm = Read-Host "Type YES to continue"
    if ($confirm -ne "YES") {
        Write-Host "Operation cancelled." -ForegroundColor Red
        return
    }
}
catch {
    Write-Host "Unable to verify AWS account. Check credentials." -ForegroundColor Red
    return
}


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
function Get-MFAReport {
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
