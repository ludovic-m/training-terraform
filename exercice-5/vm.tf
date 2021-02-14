resource "azurerm_linux_virtual_machine" "vm_training" {
  name                            = "vm-${terraform.workspace}-training"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg_training.name
  size                            = "Standard_DS2_v2"
  admin_username                  = "avanade"
  network_interface_ids           = [azurerm_network_interface.nic_training.id]
  disable_password_authentication = true
  admin_password                  = "some-secret-you-dont-commit-in-git"

  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = "<pub_key>"
  # }

  os_disk {
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
