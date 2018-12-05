resource "azurerm_network_security_group" "nsg_subnet_coding_dojo" {
   name = "nsg_subnet_${terraform.workspace}_coding_dojo"
   resource_group_name = "${azurerm_resource_group.rg_coding_dojo.name}"
   location = "${var.location}"
}