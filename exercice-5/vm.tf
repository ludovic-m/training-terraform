resource "azurerm_virtual_machine" "vm_training" {
  name                  = "vm-${terraform.workspace}-training"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg_training.name
  network_interface_ids = [azurerm_network_interface.nic_training.id]
  vm_size               = "Standard_DS2_v2"

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "vm-${terraform.workspace}-training-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vm${terraform.workspace}training"
    admin_username = "avanade"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/avanade/.ssh/authorized_keys"
      key_data = "<ssh_pub_key>"
    }
  }
}
