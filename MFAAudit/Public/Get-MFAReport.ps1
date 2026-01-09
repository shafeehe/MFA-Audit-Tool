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
