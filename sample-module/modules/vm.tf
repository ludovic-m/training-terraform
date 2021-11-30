resource "azurerm_linux_virtual_machine" "main" {
  for_each                        = var.vms
  name                            = "vm-${terraform.workspace}-training-${each.value.name}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg_training.name
  size                            = "Standard_DS2_v2"
  admin_username                  = "avanade"
  network_interface_ids           = [azurerm_network_interface.nic_training[each.key].id]
  availability_set_id             = azurerm_availability_set.as_training.id
  disable_password_authentication = false
  admin_password                  = "Password1$Password1$"

  # admin_ssh_key {
  #   username   = "avanade"
  #   public_key = "<pub_key>"
  # }

  os_disk {
    name                 = "vm-${terraform.workspace}-training-osdisk-${each.value.name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
