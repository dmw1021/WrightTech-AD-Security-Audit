# WrightTech Active Directory Security Audit

Import-Module ActiveDirectory

Write-Host "WrightTech Active Directory Security Audit"
Write-Host "=========================================="

# Audit 1: Passwords that never expire

Write-Host ""
Write-Host "Passwords That Never Expire"
Write-Host "---------------------------"

Get-ADUser -Filter * -Properties PasswordNeverExpires |
    Where-Object { $_.PasswordNeverExpires -eq $true } |
    Select-Object Name, SamAccountName, Enabled | Out-Host

# Audit 2: Inactive accounts

Write-Host ""
Write-Host "Inactive Accounts (90+ Days)"
Write-Host "---------------------------"

$CutoffDate = (Get-Date).AddDays(-90)

Get-ADUser -Filter * -Properties LastLogonDate |
    Where-Object {
        $_.Enabled -eq $true -and
        $_.LastLogonDate -and
        $_.LastLogonDate -lt $CutoffDate
    } |
    Select-Object Name, SamAccountName, LastLogonDate | Out-Host

# Audit 3: Privileged accounts

Write-Host ""
Write-Host "Domain Admins Group Members"
Write-Host "---------------------------"

Get-ADGroupMember -Identity "Domain Admins" |
    Select-Object Name, SamAccountName, objectClass |
    Out-Host

# Audit 4: Export security findings to CSV

Write-Host ""
Write-Host "Exporting Security Audit Report..."

$ReportPath = "C:\WrightTech-Audit\AD-SecurityReport.csv"

$PasswordFindings = Get-ADUser -Filter * -Properties PasswordNeverExpires |
    Where-Object { $_.PasswordNeverExpires -eq $true } |
    Select-Object Name, SamAccountName,
        @{Name="Finding";Expression={"Password Never Expires"}}

$InactiveFindings = Get-ADUser -Filter * -Properties LastLogonDate |
    Where-Object {
        $_.Enabled -eq $true -and
        $_.LastLogonDate -and
        $_.LastLogonDate -lt $CutoffDate
    } |
    Select-Object Name, SamAccountName,
        @{Name="Finding";Expression={"Inactive 90+ Days"}}

$AdminFindings = Get-ADGroupMember -Identity "Domain Admins" |
    Select-Object Name, SamAccountName,
        @{Name="Finding";Expression={"Domain Admin Member"}}

$AllFindings = @($PasswordFindings) +
               @($InactiveFindings) +
               @($AdminFindings)

$AllFindings | Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "Report saved to $ReportPath"