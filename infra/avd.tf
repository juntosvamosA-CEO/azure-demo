resource "azurerm_virtual_desktop_workspace" "ws" {
  name                = "ws-lab-vdi"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  friendly_name       = "Enterprise VDI Lab"
}

resource "azurerm_virtual_desktop_host_pool" "hp" {
  name                     = "hp-lab-pooled"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  type                     = "Pooled"
  load_balancer_type       = "BreadthFirst"
  validate_environment     = false
  start_vm_on_connect      = true
  custom_rdp_properties    = "targetisaadjoined:i:1;drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;"
  preferred_app_group_type = "Desktop"
}

resource "azurerm_virtual_desktop_application_group" "dag" {
  name                = "dag-lab-desktop"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.hp.id
  friendly_name       = "Lab Desktop"
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "ws_dag" {
  workspace_id         = azurerm_virtual_desktop_workspace.ws.id
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
}

# Assign "Desktop Virtualization User" role to the AVD-Users group
# This allows them to launch the app group.
resource "azurerm_role_assignment" "dag_access" {
  scope                = azurerm_virtual_desktop_application_group.dag.id
  role_definition_name = "Desktop Virtualization User"
  principal_id         = azuread_group.avd_users.object_id
}
