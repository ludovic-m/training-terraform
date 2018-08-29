variable "vnet_coding_dojo_name" {
  default = "vnet_coding_dojo"
}

variable "subnet_coding_dojo_name" {
  default = "subnet_coding_dojo"
}

variable "vnet_address_space" {
  default = ["10.0.0.0/16"]
}

variable "vnet_dns_servers" {
  default = ["10.0.0.4"]
}

variable "subnet_address_prefix" {
  default = "10.0.1.0/24"
}

resource "azurerm_virtual_network" "vnet_coding_dojo" {
  name                = "${var.vnet_coding_dojo_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg_coding_dojo.name}"
  address_space       = "${var.vnet_address_space}"
  dns_servers         = "${var.vnet_dns_servers}"
}

resource "azurerm_subnet" "subnet_coding_dojo" {
  name                 = "${var.subnet_coding_dojo_name}"
  resource_group_name  = "${azurerm_resource_group.rg_coding_dojo.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet_coding_dojo.name}"
  address_prefix       = "${var.subnet_address_prefix}"
  network_security_group_id = "${azurerm_network_security_group.nsg_subnet_coding_dojo.id}"
}
