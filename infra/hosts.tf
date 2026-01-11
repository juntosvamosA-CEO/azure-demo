# Generates a registration token for the Host Pool
resource "azurerm_virtual_desktop_host_pool_registration_info" "token" {
  hostpool_id    = azurerm_virtual_desktop_host_pool.hp.id
  expiration_date = timeadd(timestamp(), "2h")
}

# Network Interface for Session Hosts
resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "nic-sh-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_hosts.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Windows 11 Enterprise Multi-session VM
resource "azurerm_windows_virtual_machine" "vm" {
  count                 = 2
  name                  = "vm-sh-${count.index}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_D2s_v3"
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  admin_username        = var.admin_username
  admin_password        = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-23h2-avd"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Extension 1: Entra ID Join (AAD Join)
resource "azurerm_virtual_machine_extension" "aad_join" {
  count                      = 2
  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[count.index].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

# Extension 2: AVD Agent Registration (DSC)
resource "azurerm_virtual_machine_extension" "avd_agent" {
  count                      = 2
  name                       = "AVDClient"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[count.index].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
        "configurationFunction": "Configuration.ps1\\AddSessionHost",
        "properties": {
          "hostPoolName": "${azurerm_virtual_desktop_host_pool.hp.name}",
          "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.token.token}",
          "aadJoin": true
        }
    }
SETTINGS

  depends_on = [azurerm_virtual_machine_extension.aad_join]
}
