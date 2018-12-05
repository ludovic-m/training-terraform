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
  name                = "vnet_coding_dojo"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg_coding_dojo.name}"
  address_space       = "${var.vnet_address_space}"
  dns_servers         = "${var.vnet_dns_servers}"
}

resource "azurerm_subnet" "subnet_coding_dojo" {
  name                 = "subnet_coding_dojo"
  resource_group_name  = "${azurerm_resource_group.rg_coding_dojo.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet_coding_dojo.name}"
  address_prefix       = "${var.subnet_address_prefix}"
}
