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

# Look at the mailbox access

Get-MailboxPermission -Identity $Mailbox -User $env:USERNAME

# Grant full access to the mailbox

Write-Host "Removing full access on mailbox `"$( $Mailbox.Name )`" from `"$( $env:USERNAME )`"" -ForegroundColor Green

Remove-MailboxPermission -Identity $Mailbox -User $env:USERNAME -AccessRights fullaccess -InheritanceType All -Confirm:$false

# Look at the mailbox access again

Get-MailboxPermission -Identity $Mailbox -User $env:USERNAME
