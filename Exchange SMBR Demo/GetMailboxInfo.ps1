$ErrorActionPreference = "Stop"

#Add Exchange snapin if not already loaded in the PowerShell session

if ( Test-Path $env:ExchangeInstallPath\bin\RemoteExchange.ps1 )
{
	. $env:ExchangeInstallPath\bin\RemoteExchange.ps1
}
else
{
    Write-Warning "Exchange Server management tools are not installed on this computer."
    EXIT
}

# Connect to Exchange

Connect-ExchangeServer -Auto -AllowClobber

# Get the mailbox name

#$MailboxName = "MM-ExchUser02"

$MailboxName = Read-Host -Prompt "Enter the mailbox name"

# Get the mailbox

$Mailbox = Get-Mailbox -Identity $MailboxName

# Get the database for the mailbox

$Database = Get-MailboxDatabase -Identity $Mailbox.Database

# Get info about the database copies

$DatabaseStatus = Get-MailboxDatabaseCopyStatus | Where-Object { $_.DatabaseName -eq $Database.Name }

# Return details about the mailbox

$DatabaseStatus `
| Select-Object  `
     @{ Name = "Mailbox";  Expression = { $Mailbox.Name } }, `
     @{ Name = "Database"; Expression = { $_.DatabaseName } }, `
     @{ Name = "Active";   Expression = { $_.ActiveCopy } }, `
     @{ Name = "Server";   Expression = { $_.MailboxServer } }, `
     @{ Name = "EdbVol";   Expression = { $_.DatabaseVolumeMountPoint } }, `
     @{ Name = "LogVol";   Expression = { $_.LogVolumeMountPoint } }


