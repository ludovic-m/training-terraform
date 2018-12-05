resource "azurerm_managed_disk" "datadisk_coding_dojo" {
  count                = "${length(var.nic_private_ip)}"
  name                 = "vm_${terraform.workspace}_coding_dojo_${count.index+1}_datadisk"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.rg_coding_dojo.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1024"

  tags {
    environment = "${terraform.workspace}"
  }
}
