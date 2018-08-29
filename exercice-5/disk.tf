variable "datadisk_coding_dojo_name" {
  default = "datadisk_coding_dojo"
}

resource "azurerm_managed_disk" "datadisk_coding_dojo" {
  count                = "${length(var.nic_private_ip)}"
  name                 = "${var.vm_coding_dojo_name}_${count.index+1}_datadisk"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.rg_coding_dojo.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1024"

  tags {
    environment = "${terraform.workspace}"
  }
}
