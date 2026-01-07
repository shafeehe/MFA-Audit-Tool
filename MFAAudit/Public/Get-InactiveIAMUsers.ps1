#Function to identify the inactive users who have not been active for the last 90 days

function Get-InactiveIAMUsers {
    [CmdletBinding()]
    param(
         [int]$Days = 90
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



        $status = if($inactive) {"Inactive"} else {"Active"}
        $DaysInactive = if ($LastActivity) { [int]((Get-Date) - $LastActivity).TotalDays }
                        else { $null }

     
        [PSCustomObject]@{
            UserName = $user
            LastActivity = $LastActivity
            Status = $status 
            DaysInactive = $DaysInactive
        }
    }
}
