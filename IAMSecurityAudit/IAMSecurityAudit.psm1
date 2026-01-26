# Load public functions
Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse | 
ForEach-Object {. $_} 
Export-ModuleMember -Function *

Update-TypeData -TypeName IAMSecurityAudit.InactiveUser `
    -DefaultDisplayPropertySet UserName, Status, DaysInactive, LastActivity `
    -Force
