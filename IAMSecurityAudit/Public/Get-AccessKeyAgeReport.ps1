function Get-AccessKeyAgeReport {
    [CmdletBinding()]
    param (
        [int]$Days = 90,    #Best Security Practice Recommendation by AWS is 90 days
        [switch]$OnlyOld     
        )    
    

    $thresholdDate = (Get-Date).AddDays(-$Days)

    Request-IAMCredentialReport -Force | Out-Null

    $report = $null
    for ($i=0; $i -lt 6 -and -not $report; $i++) {
        Start-Sleep -Seconds (2*($i+1))
        Try { $report = Get-IAMCredentialReport -Raw } Catch {}
    }

    if(-not $report) {
        throw "Couldn't retrieve IAM credential report from AWS" }

    $rows = $report -split "`n" | ConvertFrom-Csv


    

    foreach($r in $rows) {
        if (-not $r.user -or $r.user -eq '<root_account>') {continue}

        $HasActiveKeys = $false

        foreach ($keyIndex in 1,2) {
            $ActiveField = "access_key_${keyIndex}_active"
            $DateField  = "access_key_${keyIndex}_last_rotated"

            if ($r.$ActiveField -ne 'true') {continue }

            try { 
                $LastRotatedDate = ([datetime]::Parse($r.$DateField)) }
            catch { 
                Write-Warning "Missing or invalid rotation date for $($r.user) AccessKey$keyIndex"
                continue
                  }
           

            $AgeInDays = [int]((Get-Date) - $LastRotatedDate).TotalDays
            $Needs_Rotation = $LastRotatedDate -lt $thresholdDate

            if ($OnlyOld -and -not $Needs_Rotation) { continue }

            [PSCustomObject]@{
                UserName = $r.user
                KeySlot = "AccessKey $keyIndex"
                LastRotated = $LastRotatedDate
                KeyAge = $AgeInDays
                Needs_Rotation = $Needs_Rotation 
            }

            $HasActiveKeys = $true
        }

        if (-not $HasActiveKeys) {
            [PSCustomObject]@{
                UserName = $r.user
                KeySlot = 'No active access keys'
                LastRotated = $null
                KeyAge = $null
                Need_Rotation = $false
            }

        }
    } 

}







