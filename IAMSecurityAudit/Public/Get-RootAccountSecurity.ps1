function Get-RootAccountSecurity  {
    [CmdletBinding() ]
    param() 

    
    Request-IAMCredentialReport -Force | Out-Null

    $report = $null
    for($i = 0; $i -lt 6 -and -not $report; $i++) {
        Start-Sleep -Seconds (2*($i+1))  
        try { $report = Get-IAMCredentialReport -Raw } catch {}
        }

            
    if (-not $report) {
        ( throw "Could not get the IAM Credential Report from AWS") } 
    
    $rows = $report -split '`n'| ConvertFrom-Csv


    $root = $rows | Where-Object {$_.user -eq '<root_account>'}  #extract the rootuser from $rows

    if (-not $root) { 
        throw "root account entry not found in credential report" }

    #MFA
    $MFAEnabled = ($root.mfa_active -eq $true)


    #Active access keys
    $Active_Access_keys = 0
    if ($root.access_key_1_active -eq $true) { $Active_Access_keys++ }
    if ($root.access_key_2_active -eq $true) { $Active_Access_keys++ }


    #Console Password Access
    $ConsoleLastUsed = $null
    try {
        if ($root.password_last_used -and $root.password_last_used -notin @('no_information', 'N/A')) {
        $ConsoleLastUsed = [datetime]::Parse($root.password_last_used)  }
        }
    catch {}

    #Findings and Risk Level
    $Findings = @()
    $Risk_Level = 'LOW'

    if (-not $MFAEnabled) {
        $Findings += "MFA is not enabled for your root account"
        $Risk_Level = 'CRITICAL'  }

    if ($Active_Access_keys -gt 0) {
        $Findings += "Active access keys are present in your root account"
        $Risk_Level = 'CRITICAL' }

    

    if ($ConsoleLastUsed) {
        $DaysSinceRootLogin = ((Get-Date) - $ConsoleLastUsed).TotalDays

        if ($DaysSinceRootLogin -lt 90) {
        
            $Findings += "Root account used for console login recently (within the last 90 days). Please double check any potential actions!"
            if ($Risk_Level -ne 'CRITICAL') {
                $Risk_Level = 'HIGH' } 
            }

        else {
            $Findings += "Root Console last used on $($ConsoleLastUsed.ToString('dd-MM-yyyy')) (older than $DaysSinceRootLogin Days) " 
            } 
        }
        

     if ($Findings.Count -eq 0) {
        $Findings += 'No root account security issues detected' }


    [PSCustomObject]@{
        AccountType = 'Root'
        MFA_Enabled = $MFAEnabled
        Active_Access_Keys = $Active_Access_keys
        Console_Last_Used = $ConsoleLastUsed
        Risk_Level = $Risk_Level
        Findings = ($Findings -join ';') }
}

Get-RootAccountSecurity