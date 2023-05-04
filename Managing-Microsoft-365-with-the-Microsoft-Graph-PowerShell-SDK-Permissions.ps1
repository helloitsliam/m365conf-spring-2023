# SharePoint Sites - Application
Find-MgGraphPermission sites -PermissionType Application

# Microsoft Teams - Delegated
Find-MgGraphPermission teams -PermissionType Delegated

# Find Identifiers for Specific Permission
Find-MgGraphPermission user.read

# Find Available Permissions by Searching
Find-MgGraphPermission -SearchString "user"
Find-MgGraphPermission -SearchString "user" -PermissionType Application
Find-MgGraphPermission -SearchString "user" -PermissionType Delegated
