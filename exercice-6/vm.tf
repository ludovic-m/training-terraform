resource "azurerm_virtual_machine" "vm_training" {
  count                 = var.nb_vm
  name                  = "vm-${terraform.workspace}-training-${count.index+1}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg_training.name
  network_interface_ids = [azurerm_network_interface.nic_training[count.index].id]
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
    name              = "vm-${terraform.workspace}-training-os-disk-${count.index+1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vm${terraform.workspace}training${count.index+1}"
    admin_username = "avanade"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/avanade/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCr7x+w8uxJRDEfwWWLyg9ICaIMW5EMC3BGa3zxlJO39Ya+eyIGJXXVQVXZh2osPFK94xH4Q5C6EN/urZVhBNzsg1X73aV7tF14H2AY7Sw3y3JxBmICPylD9dxUSfthclsljO8z2/pYKAaTM2Q12FpJgo67CpNsmOCdpBuC2PcZrfNl+PeVfyWQY4e+q0R0pdMxCHZM6zGVFQIW8I7Hf3W/KMwEIi0apncTRn7y6wNmRKrngBKXv6MfD8xRF1B2vYTFjuX/Yzjtm/PBpDUzmQuPlapeuvRUhcZIyAqhRrCvcYXH+dgR6/W1OVh7xgXBpynTFfk7F7jhweAfPEYQgyLJ2fYV78tTA+W5aWz30vzETuM3ZMEwRSnsL25O6IoJ422HGwIxF32J6Rln0c3EU+K1Fw6sRYdEckhK2LbBy5MwnmT3A1N6Sv/G8Mg2ENpy/FVkK+ojMUQsMVIZhKpXaTXQoZ2++Lk5Fzs/6YyEfD1vGlcwnoRpebMViTHlzFNLuw4ddrtbdDF6Lnt0KCIRyDjLrKHO3Qw+2IVLz95KM4fZzgd9AovPebFjFItQG2rb9BQgnj4ihtG90RURsUsRLdlx6853itIrQwZcLVOUv/OzEm0ZCxxI8gaKf0vYvc3anFyKWvfmu14uOPQ+PPFJHqhRoin5TJs72w5DcQmFXpMXvw== ludovic.medard.c@thalesdigital.io"
    }
  }
}
