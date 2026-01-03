$Public = Join-Path $PSScriptRoot "Public\*.ps1"
Get-ChildItem $Public | ForEach-Object { . $_ }

Export-ModuleMember -Function Get-MFAReport