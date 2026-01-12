<#
.SYNOPSIS
Identifies AWS IAM users who have inactive for a specified number of days.

.DESCRIPTION
This cmdlet analyzes AWS IAM credential report data to determine the most recent
activity for each IAM user (console password usage or access key usage).

The cmdlet returns structured objects that can be filtered, sorted,
or exported using standard PowerShell pipelines.

.PARAMETER Days
Number of days since the user's last activity.
Default is 90 days.

.EXAMPLE
Get-InactiveIAMUsers -->  Returns all IAM users and their activity status using the default 90-day threshold.

.EXAMPLE
Get-InactiveIAMUsers -Days 120 -->   Check IAM Users inactive for more than 120 days.

.EXAMPLE
Get-InactiveIAMUsers | Where-Object Status -eq "Inactive" --> returns only the inactive users.

.EXAMPLE
Get-InactiveIAMUsers | Export-Csv filename.csv -NoTypeInformation --> exports the report as a csv file.

.NOTES

Author: Mohammed Shafeehe
Module: MFAAudit
Requires: AWS.Tools.IdentityManagement
#>
function Get-InactiveIAMUsers {
    [CmdletBinding()]
    param(
         [int]$Days = 90,

         [switch]$OnlyInactive
    )
    
    $threshold = (Get-Date).AddDays(-$Days) 

    Request-IAMCredentialReport -Force | Out-Null

    $report = $null
    for($i=0; $i -lt 6 -and -not $report; $i++) {
        Start-Sleep -Seconds (2*($i+1))
        try { $report = Get-IAMCredentialReport -Raw } catch {}
    }

    if(-not $report) { throw "Could not get credentials report from AWS end" }



    function Parse-DateSafe($s) {
        if ([string]::IsNullOrWhiteSpace($s) -or $s -in @("no_information", "N/A") ) { return $null}
        try { [datetime]::Parse($s) } catch {$null} 
    }



    $rows = $report -split "`n" | ConvertFrom-Csv


    $TotalUsers = 0
    $ActiveUsers = 0
    $InactiveUsers = 0

    foreach ($r in $rows) {
        $user = $r.user
        if (-not $user -or $user -eq "<root_account>") { continue }

        $pwLast = Parse-DateSafe $r.password_last_used
        $ak1Last = Parse-DateSafe $r.access_key_1_last_used_date
        $ak2Last = Parse-DateSafe $r.access_key_2_last_used_date

        $candidates = ($pwLast, $ak1Last, $ak2Last) | Where-Object { $_ }
        $LastActivity = if($candidates) { ($candidates | Sort-Object -Descending)[0] } 
                        else { $null }
        $inactive = ($LastActivity -eq $null) -or ($LastActivity -lt $threshold)
        if ($OnlyInactive -and -not $inactive) { continue }

        $TotalUsers ++
        if ($inactive) { $InactiveUsers++ }
        else { $ActiveUsers++ }


        $status = if($inactive) {"Inactive"} else {"Active"}
        $DaysInactive = if ($LastActivity) { [int]((Get-Date) - $LastActivity).TotalDays }
                        else { $null }

     
        [PSCustomObject]@{
            RecordType = 'IAM User'
            UserName = $user
            LastActivity = $LastActivity
            Status = $status 
            DaysInactive = $DaysInactive
        }


        
    }

    [PSCustomObject]@{
            RecordType = 'Summary'
            TotalUsers = $TotalUsers
            ActiveUsers = $ActiveUsers
            InactiveUsers = $InactiveUsers
        }
}
