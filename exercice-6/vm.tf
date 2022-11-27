resource "azurerm_linux_virtual_machine" "vm_training" {
  count                           = var.nb_vm
  name                            = "vm-${terraform.workspace}-training-${count.index + 1}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg_training.name
  size                            = "Standard_D2s_v3"
  admin_username                  = "azureuser"
  network_interface_ids           = [azurerm_network_interface.nic_training[count.index].id]
  availability_set_id             = azurerm_availability_set.as_training.id
  disable_password_authentication = true

  custom_data = filebase64("cloud-init.txt")

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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