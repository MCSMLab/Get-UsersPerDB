<#
Get-UsersPerDB
v1.6
12/21/2015
By Nathan O'Bryan
nathan@mcsmlab.com
http://www.mcsmlab.com

THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT
WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
FOR A PARTICULAR PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR 
RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

This script shows how many mailboxes are in each of your Exchange databases along
with the database sizes.

Change Log
1.5 - Added option to connect to remote Exchange server
1.6 - Added output to results.csv file

#>
Clear-Host

$Answer = Read-Host "Do you want to connect to a remote Exchange server? [Y/N]"

If ($Answer -eq "Y" -or $Answer -eq "y")
{
$ExchangeServer = Read-Host "Enter the FQDN of your Exchange server"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$ExchangeServer/PowerShell/ -Authentication Kerberos
Import-PSSession $Session
}

Write-Host “Listing each mailbox database, mailbox count, and database size“

ForEach ($DBName in Get-MailboxDatabase)
{
Write-Host
$Count= (Get-Mailbox -Database $DBName -ResultSize Unlimited).Count
$Size= (Get-MailboxDatabase -Identity $DBName -Status).DatabaseSize
$SrvName= (Get-MailboxDatabase -Identity $DBName -Status).ServerName
$LstBackup= (Get-MailboxDatabase -Identity $DBName –Status).LastFullBackup

Write-Output "Database:         $DBName"
Write-Output "Server:           $SrvName"
Write-Output "Mailboxes:        $Count" 
Write-Output "Size:             $Size"
Write-Output "Last Full Backup: $LstBackup"


Write-Output $DBName $SrvName $Count $Size $LstBackup     >> c:\Logs\Results.csv
}