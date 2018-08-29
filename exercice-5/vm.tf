variable "vm_coding_dojo_name" {
  default = "vm_coding_dojo"
}

variable "vm_coding_dojo_hostname" {
  default = "vmcodingdojo"
}

variable "vm_admin_username" {}

variable "vm_admin_password" {}

resource "azurerm_virtual_machine" "vm_coding_dojo" {
  count                 = "${length(var.nic_private_ip)}"
  name                  = "${var.vm_coding_dojo_name}_${count.index}"
  resource_group_name   = "${azurerm_resource_group.rg_coding_dojo.name}"
  location              = "${var.location}"
  network_interface_ids = ["${element(azurerm_network_interface.nic_coding_dojo.*.id, count.index)}"]
  availability_set_id   = "${azurerm_availability_set.as_coding_dojo.id}"
  vm_size               = "Standard_D2s_v3"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "14.04.2-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_coding_dojo_name}_${count.index}_osdisk"
    managed_disk_type = "Premium_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  storage_data_disk {
    name              = "${var.vm_coding_dojo_name}_${count.index+1}_datadisk"
    managed_disk_id   = "${element(azurerm_managed_disk.datadisk_coding_dojo.*.id, count.index)}"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = "1024"
    create_option     = "Attach"
    lun               = 0
  }

  os_profile {
    computer_name  = "${var.vm_coding_dojo_hostname}${count.index}"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${var.vm_admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
