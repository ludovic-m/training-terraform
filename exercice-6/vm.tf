resource "azurerm_linux_virtual_machine" "vm_training" {
  count                           = var.nb_vm
  name                            = "vm-${terraform.workspace}-training-${count.index + 1}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg_training.name
  size                            = "Standard_DS2_v2"
  admin_username                  = "avanade"
  network_interface_ids           = [azurerm_network_interface.nic_training[count.index].id]
  disable_password_authentication = false
  admin_password                  = "Some-Secret-You-Dont-Commit-In-Git"

  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = "<pub_key>"
  # }

  os_disk {
    name                 = "vm-${terraform.workspace}-training-os-disk-${count.index + 1}"
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