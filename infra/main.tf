data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

# We specify the domain explicitly for user creation if needed, 
# or assume the running user has perms.
