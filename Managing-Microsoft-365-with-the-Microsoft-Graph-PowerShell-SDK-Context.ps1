# Check the Current Graph Context
Get-MgContext

# Check the Current Connect Scopes
Get-MgContext | Select-Object -ExpandProperty Scopes

# Check the Organization Details
Get-MgEnvironment
