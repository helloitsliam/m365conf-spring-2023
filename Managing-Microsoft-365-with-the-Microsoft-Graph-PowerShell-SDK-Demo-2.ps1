# Connect Using the Standard Command and Scopes
$scopes = @(
    "Chat.ReadWrite.All"
    "Directory.Read.All"
    "Group.Read.All"
)
Connect-MgGraph -Scopes $scopes

# Connect Using an Azure App Registration
Connect-MgGraph `
    -ClientId "<Client Id>" `
    -TenantId "<Tenant Id>" `
    -CertificateThumbprint "<Certificate Thumbprint>"
