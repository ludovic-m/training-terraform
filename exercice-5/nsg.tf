variable "nsg_subnet_coding_dojo_name" {
   default =   "nsg_subnet_coding_dojo"
}

resource "azurerm_network_security_group" "nsg_subnet_coding_dojo" {
   name = "${var.nsg_subnet_coding_dojo_name}"
   resource_group_name = "${azurerm_resource_group.rg_coding_dojo.name}"
   location = "${var.location}"
}