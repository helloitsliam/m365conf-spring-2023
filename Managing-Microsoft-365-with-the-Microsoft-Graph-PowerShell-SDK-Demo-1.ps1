# Install into the Current User Scope Only
Install-Module Microsoft.Graph -Scope CurrentUser

# Install into the All-User Scope
Install-Module Microsoft.Graph -Scope AllUsers

# Verify Installation
Get-InstalledModule Microsoft.Graph

# Verify Installation of All Modules
Get-InstalledModule

# Updating and Uninstalling
Update-Module Microsoft.Graph
Uninstall-Module Microsoft.Graph
