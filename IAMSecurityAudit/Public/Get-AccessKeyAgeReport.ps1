<#
.SYNOPSIS
Audits AWS IAM access key security posture and detects risky configurations such as access key rotation hygiene.

.DESCRIPTION
Analyzes AWS IAM credential report data to evaluate access key hygiene and exposure risks.

The cmdlet performs the following checks:

• Access keys older than the specified threshold (default: 90 days)
• Never-used access keys
• Multiple active access keys per user
• Console password + active access keys exposure

Each IAM user is evaluated and assigned a consolidated risk level
(LOW, MEDIUM, HIGH) based on detected findings.

This cmdlet returns structured objects suitable for filtering,
automation workflows, or export to reporting layers.

.PARAMETER Days
Number of days used as the rotation threshold.
Default: 90 days (AWS best practice recommendation).

.EXAMPLE
Get-AccessKeyAgeReport -OnlyRisky

.EXAMPLE
Get-AccessKeyAgeReport | Export-Csv AccessKeyAudit.csv -NoTypeInformation

.NOTES
Author: Mohammed Shafeehe
       (DevOps/Cloud Engineer)
Module: AWS IAM Security Audit Tool

#>
function Get-AccessKeyAgeReport {
    [CmdletBinding()]
    param (
        [int]$Days = 90,    #Best Security Practice Recommendation by AWS is 90 days
        [switch]$OnlyRisky     
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

        #---------------------
        # Per-user tracking
        #---------------------

        $Findings = @()
        $RiskLevel = 'LOW'
        $ActiveKeyCount = 0
        $HasConsolePassword = ($r.password_enabled -eq 'true' )




        foreach ($keyIndex in 1,2) {
            $ActiveField = "access_key_${keyIndex}_active"
            $RotateField  = "access_key_${keyIndex}_last_rotated"
            $usedField = "access_key_${keyIndex}_last_used_date"


            if ($r.$ActiveField -ne 'true') {continue }
            $ActiveKeyCount++

            #-------Rotation Age-------------

            try { 
                $LastRotatedDate = ([datetime]::Parse($r.$RotateField))
                $RotationAge = [int]((Get-Date) - $LastRotatedDate).TotalDays

                if ($LastRotatedDate -lt $thresholdDate) {
                    $Findings += " AccessKey $keyIndex older than $Days days. Needs Rotation"
                    $RiskLevel = 'HIGH'
                }
                
            }

            catch { 
                Write-Warning "Missing or invalid rotation date for $($r.user) AccessKey$keyIndex"
                continue
                  }

            #--------Never Used-------------
            if($r.$usedField -in @('N/A', 'no_information')) {
                $Findings += "AccessKey $keyIndex never used"
                if ($RiskLevel -eq 'LOW') { $RiskLevel = 'MEDIUM' }
            }
        }
           
        #-----------Multiple-------
        if ($ActiveKeyCount -gt 1 ) {
            $Findings += "Multiple active access keys"
            if ($RiskLevel -eq 'LOW') { $RiskLevel = 'MEDIUM' }
            }

        #---Both console and key--------------
        if ($ActiveKeyCount -gt 0 -and $HasConsolePassword) {
            $Findings += "Console password + Active access keys both enabled!  "
            if ($RiskLevel -eq 'LOW') { $RiskLevel = 'MEDIUM'}
        }

        #---No Findings------------
        if ($Findings.Count -eq 0) {
            $Findings += "No access key security issues detected"
        }

        #----------
        #OUTPUT
        #----------

        #Only output risky users only
        if ( $OnlyRisky -and $Findings.Count -eq 0) { continue }

        $obj = [PSCustomObject]@{
            UserName        = $r.user
            ActiveKeys      = $ActiveKeyCount
            RiskLevel       = $RiskLevel
            Findings        = ($Findings -join '; ')
        }

        $obj.PSObject.TypeNames.Insert(0, 'IAMSecurityAudit.AccessKeyAudit')

        $obj

    } 
}