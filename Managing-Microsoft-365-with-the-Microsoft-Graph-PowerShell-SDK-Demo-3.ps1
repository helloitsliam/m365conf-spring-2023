# Find available commands
Get-Command -Module Microsoft.Graph*
Get-Command -Module Microsoft.Graph* *Team*
Get-Command -Module Microsoft.Graph* *User*
Get-Command -Module Microsoft.Graph -Verb Get
Get-Command -Module Microsoft.Graph* *Team* -Verb Get
Get-Command -Module Microsoft.Graph* -Noun Group
Get-Command -Module Microsoft.Graph.Authentication

# View help for the Get-MgUser Command
Get-Help Get-MgUser
Get-Help Get-MgUser -Category Cmdlet
Get-Help Get-MgUser -Category Function
Get-Help Get-MgUser -Detailed
Get-Help Get-MgUser -Full
Get-Help Get-MgUser -ShowWindow

# View the current API endpoint version
Get-MgProfile

# Set the API to the 'beta' endpoint
Select-MgProfile -Name "beta"

# Set the API to the 'v1.0' endpoint
Select-MgProfile -Name "v1.0"


##############################
##                          ##
##          Scopes          ##
##                          ##
##############################

# Scopes to Manage Users and Groups with Full Read Write Access
$scopes = @(
    "User.ReadWrite.All"
    "Directory.ReadWrite.All"
    "Group.ReadWrite.All"
    )

# Scopes to Create Teams
$scopes = @(
    "Team.Create"
    "Group.ReadWrite.All"
    )

# Scopes to Manage SharePoint Online Sites and Files
$scopes = @(
    "Sites.FullControl.All"
    "Sites.Manage.All"
    "Sites.ReadWrite.All"
    "Files.ReadWrite.All"
    "Files.ReadWrite.AppFolder"
    )

# Scopes to Manage Mail
$scopes = @(
    "Mail.ReadWrite"
    "Mail.ReadWrite.Shared"
    "Mail.Send"
    )

# SharePoint Sites
Find-MgGraphPermission sites -PermissionType Delegated

# Microsoft Teams
Find-MgGraphPermission teams -PermissionType Delegated

# Users
Find-MgGraphPermission user -PermissionType Delegated

# eDiscovery
Find-MgGraphPermission ediscovery -PermissionType Delegated

# Connect to Microsoft 365 to Access Users and Groups
Connect-MgGraph -Scopes `
    "User.ReadWrite.All"
    "Group.ReadWrite.All"

# View Current Connection Details
Get-MgContext
(Get-MgContext).AuthType
(Get-MgContext).Scopes

# Original Connection
Connect-MgGraph -Scopes 
    "User.ReadWrite.All"
    "Group.ReadWrite.All"

# Update Connection to Allow "Group Members"
Connect-MgGraph -Scopes
    "User.ReadWrite.All"
    "Group.ReadWrite.All"
    "GroupMember.ReadWrite.All"

# Create the Certificate
$cert = New-SelfSignedCertificate `
    -Subject "CN={GraphCertificate}" `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -KeyExportPolicy Exportable `
    -KeySpec Signature `
    -KeyLength 4096 `
    -KeyAlgorithm RSA `
    -HashAlgorithm SHA256

# Export the Created Certificate
Export-Certificate -Cert $cert -FilePath "C:\Certs\{GraphCertificate}.cer"

# Set the Password and Export as "PFX"
$pwd = ConvertTo-SecureString -String "{Password}" -Force -AsPlainText
Export-PfxCertificate `
    -Cert $cert `
    -FilePath "C:\Certs\{GraphCertificate}.pfx" `
    -Password $pwd

# Connect Using an Azure App Registration
Connect-MgGraph `
    -ClientId "2f6ab55a-b61a-448e-a47e-ad5f3ad519ff" `
    -TenantId "9c7637c3-agfa-42e7-b56a-ebc98f327ec6" `
    -CertificateThumbprint "6E332BCB760DFF68D59746CE7D7367EF7EAB33C3"




#################################
##                             ##
##       User Management       ##
##                             ##
#################################

# Read Only Connection
$scopes = @(
    "User.ReadBasic.All"
    "User.Read.All"
    "Directory.Read.All"
    )
Connect-MgGraph -Scopes $scopes


# Read and Write Connection
$scopes = @(
    "User.ReadWrite.All"
    "Directory.ReadWrite.All"
    )
Connect-MgGraph -Scopes $scopes

# Retrieve All Users
Get-MgUser | Format-List ID, DisplayName, Mail, UserPrincipalName

# Retrieve Specific User by ID
Get-MgUser -UserId '5f2db099-011c-429d-8ba3-4158e2bec2ae' | `
    Format-List ID, DisplayName, Mail, UserPrincipalName

# Retrieve Users by Filtering
Get-MgUser -ConsistencyLevel eventual -Filter "startsWith(Mail, 'user')"

# Create a New User Account (Backticks)
$password = @{ Password = 'KHCZ#2++QGDHfTEs' }
New-MgUser `
    -DisplayName 'User Account' `
    -PasswordProfile $password `
    -AccountEnabled `
    -MailNickName 'UserAccount' `
    -UserPrincipalName 'psuseraccount@M365x42854609.onmicrosoft.com'

# Update User Using ID
Update-MgUser `
    -UserId '5f2db099-011c-429d-8ba3-4158e2bec2ae' `
    -DisplayName 'New Display Name'


# Retrieve User Using Filtering, Then Update
$user = Get-MgUser `
    -ConsistencyLevel eventual `
    -Filter "startsWith(Mail, 'psuseraccount')" -Top 1
$user | Update-MgUser -DisplayName 'New Display Name'

# Remove User by ID
Remove-MgUser -UserId '5f2db099-011c-429d-8ba3-4158e2bec2ae'

# Remove User by ID with no Confirmation
Remove-MgUser -UserId '5f2db099-011c-429d-8ba3-4158e2bec2ae' -Confirm

# Retrieve User Using Filtering, Then Delete
$user = Get-MgUser `
    -ConsistencyLevel eventual `
    -Filter "startsWith(Mail, 'psuseraccount')" -Top 1
$user | Remove-MgUser -Confirm


#################################
##                             ##
##      Groups Management      ##
##                             ##
#################################

# Read Only Connection
$scopes = @("Group.Read.All")
Connect-MgGraph -Scopes $scopes

# Read and Write Connection
$scopes = @("Group.ReadWrite.All")
Connect-MgGraph -Scopes $scopes


# Read and Write Connection Including Group Memberships
$scopes = @(
    "Group.ReadWrite.All"
    "GroupMember.ReadWrite.All"
    )
Connect-MgGraph -Scopes $scopes

# Retrieve All Groups
Get-MgGroup | Format-List ID, DisplayName, Description, GroupTypes

# Retrieve Specific Group by ID
Get-MgGroup -GroupId 'f357cbb9-4c31-42c3-9b4f-22cb4202d185' | `
    Format-List ID, DisplayName, Description, GroupTypes

# Retrieve Groups by Filtering
Get-MgGroup -ConsistencyLevel eventual -Filter "startsWith(DisplayName, 'group')"

# Create a New Group
New-MgGroup `
    -DisplayName 'Group' `
    -MailEnabled: $False `
    -MailNickName 'group' `
    -SecurityEnabled

# Update Group Using ID
$properties = @{ 
    "Description" = "New Group Name"
    "DisplayName" = "New Group Description"
}
Update-MgGroup `
    -GroupId '2dc7ce8c-b60e-4d20-976d-0580f5ae3ce3' `
    -BodyParameter $properties

# Remove Group by ID
Remove-MgGroup -GroupId '2dc7ce8c-b60e-4d20-976d-0580f5ae3ce3'

# Remove Group by ID with No Confirmation
Remove-MgGroup -GroupId '2dc7ce8c-b60e-4d20-976d-0580f5ae3ce3' -Confirm

# Retrieve Group Using Filtering, Then Delete
$group = Get-MgGroup `
    -ConsistencyLevel eventual `
    -Filter "startsWith(DisplayName, 'group')" -Top 1
$group | Remove-MgGroup -Confirm

# Add a Group Member
$user = Get-MgUser `
    -ConsistencyLevel eventual `
    -Search '"DisplayName:User"'

$group = Get-MgGroup -GroupId '2dc7ce8c-b60e-4d20-976d-0580f5ae3ce3'

New-MgGroupMember `
    -GroupId $group.Id `
    -DirectoryObjectId $user.Id


#################################
##                             ##
##       Exchange Online       ##
##                             ##
#################################

# Connection for Creating, Reading, Updating, and Deleting Mail
$scopes = @("Mail.ReadWrite")
Connect-MgGraph -Scopes $scopes

# Connection for Sending Mail as Users in the Organization
$scopes = @("SMTP.Send")
Connect-MgGraph -Scopes $scopes

# Connection for Creating, Reading, Updating, and Deleting Events in User Calendars
$scopes = @("Calendars.ReadWrite")
Connect-MgGraph -Scopes $scopes

# Core Connection for Managing Mail and Calendar
$scopes = @("Mail.ReadWrite","Calendars.ReadWrite")
Connect-MgGraph -Scopes $scopes


##################################
##                              ##
##      SharePoint Online       ##
##                              ##
##################################

# Connection for Creating, Reading, Updating, and Deleting Files
$scopes = @("Files.ReadWrite.All")
Connect-MgGraph -Scopes $scopes

# Connection for Managing Sites
$scopes = @("Sites.Manage.All")
Connect-MgGraph -Scopes $scopes

# Core Connection for Managing Sites and Files
$scopes = @("Files.ReadWrite.All","Sites.FullControl.All")
Connect-MgGraph -Scopes $scopes


################################
##                            ##
##      Microsoft Teams       ##
##                            ##
################################

# Connection for Creating a Team
$scopes = @("Team.Create")
Connect-MgGraph -Scopes $scopes

# Connection for Configuring Team Settings
$scopes = @("TeamSettings.ReadWrite.All")
Connect-MgGraph -Scopes $scopes

# Connection for Configuring Team Tabs
$scopes = @("TeamsTab.Create","TeamsTab.ReadWrite.All")
Connect-MgGraph -Scopes $scopes

# Connection for Managing Team Members
$scopes = @("TeamMember.ReadWrite.All")
Connect-MgGraph -Scopes $scopes

# Core Connection for Managing Teams
$scopes = @(
    "Team.Create"
    "TeamSettings.ReadWrite.All"
    "TeamsTab.ReadWrite.All"
    "TeamsTab.Create"
    "TeamMember.ReadWrite.All"
    "Group.ReadWrite.All"
    "GroupMember.ReadWrite.All"
    )
Connect-MgGraph -Scopes $scopes


############################
##                        ##
##      Mail Actions      ##
##                        ##
############################

# Retrieve Mailbox, Folders and Messages
Connect-MgGraph -Scopes "Mail.Read"

$user = Get-MgUser -Filter "UserPrincipalName eq 'user@domain.com'"

$mailfolders = Get-MgUserMailFolder -UserId $user.Id -All

$inboxfolder = $mailfolders | Where-Object {$_.DisplayName -eq "Inbox"}

$messages = Get-MgUserMailFolderMessage `
    -All `
    -UserId $user.Id `
    -MailFolderId $inboxfolder.Id

$messages | Select-Object Subject


# Retrieving Calendars and Events
Connect-MgGraph -Scopes "Calendars.Read"

$user = Get-MgUser -Filter "UserPrincipalName eq 'user@domain.com'"

$calendar = Get-MgUserCalendar -UserId $user.Id -All

$events = Get-MgUserCalendarEvent `
    -All `
    -UserId $user.Id `
    -CalendarId $calendar.Id

$events | Select-Object Subject


#####################################
##                                 ##
##      File and Site Actions      ##
##                                 ##
#####################################

# Retrieve File Drive
Get-MgDrive -All | Select-Object Name

# Retrieve Files from Drive
$drive = Get-MgDrive -Top 1
Get-MgDriveListItem -DriveId $drive.Id

# Retrieve Drive List
$drive = Get-MgDrive -Top 1
Get-MgDriveList -DriveId $drive.Id

# Retrieve Drive Activity
$drive = Get-MgDrive -Top 1
Get-MgDriveListActivity -DriveId $drive.Id

# Retrieve Site
Get-MgSite -SiteId root

# Search for Sites
Get-MgSite -Search "Operations" | Select-Object DisplayName, Description, WebUrl

# Retrieve Site Columns
$site = Get-MgSite -Search "Safety" -Top 1
Get-MgSiteColumn -SiteId $site.Id | Select-Object DisplayName

# Retrieve Site Lists
$site = Get-MgSite -Search "Safety" -Top 1
Get-MgSiteList -SiteId $site.Id


#############################
##                         ##
##      Teams Actions      ##
##                         ##
#############################

# Retrieve Microsoft 365 Group and Team
$group = Get-MgGroup -Filter "DisplayName eq 'Sales Planning'"
Get-MgTeam -TeamId $group.Id

# Create a New Team
Using Namespace Microsoft.Graph.PowerShell.Models
[MicrosoftGraphTeam1]@{
    Template = [MicrosoftGraphTeamsTemplate]@{
        Id = 'com.microsoft.teams.template.OrganizeHelpDesk'
    }
    DisplayName = "Team"
    Description = "Team Description"
} | New-MgTeam

# Create a Team Channel
$group = Get-MgGroup -Filter "DisplayName eq 'Sales Planning'"
$team = Get-MgTeam -TeamId $group.Id

$channelname = "Channel"
$channeldescription = "Channel Description"

$channel = New-MgTeamChannel `
    -TeamId $team.GroupId `
    -DisplayName $channelname `
    -Description $channeldescription

# Retrieve User Details
$email = "user@domain.com"
$user = Get-MgUser -UserId $email

# Retrieve Team and Add an Owner
$group = Get-MgGroup -Filter "DisplayName eq 'Sales Planning'"
$team = Get-MgTeam -TeamId $group.Id

$ownerproperties = @{
    "@odata.type" = "#microsoft.graph.aadUserConversationMember";
    "user@odata.bind" = "https://graph.microsoft.com/beta/users/" + $user.Id
}
$role = "owner"

New-MgTeamMember -TeamId $team.GroupId -Roles $role `
    -AdditionalProperties $ownerproperties


##################################
##                              ##
##      Remapping Commands      ##
##                              ##
##################################

Connect-AzureAD
$user = Get-AzureADUser -SearchString "User"
Set-AzureADUser -ObjectId $user.Id -Displayname "Updated User"

Connect-MgGraph -Scopes "User.ReadWrite.All"
$user = Get-MgUser -ConsistencyLevel eventual -Search "mail:user@domain.com"
Update-MgUser -UserId $user.Id -Displayname "Updated User"


Connect-AzureAD
$user = Get-AzureADUser -SearchString "User"
$group = Get-AzureADGroup -SearchString "Group"
Add-AzureADGroupMember -ObjectId $group.ObjectId -RefObjectId $user.Id

$scopes = @(
    "User.ReadWrite.All",
    "Group.ReadWrite.All",
    "GroupMember.ReadWrite.All"
    )
Connect-MgGraph -Scopes $scopes
$user = Get-MgUser -ConsistencyLevel eventual -Search "mail:user@domain.com"
$group = Get-MgGroup -Filter "DisplayName eq 'Group'"
New-MgGroupMember -GroupId $group.ObjectId -DirectoryObjectId $user.Id


Connect-AzureAD
New-AzureADMSApplication -DisplayName "Application" -IdentifierUris "http://m365x.onmicrosoft.com"

$scopes = @(
    "Application.ReadWrite.All"
    )
Connect-MgGraph -Scopes $scopes
New-MgApplication -DisplayName "Application" -IdentifierUris "http://m365x.onmicrosoft.com"













