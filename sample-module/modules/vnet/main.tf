resource "azurerm_resource_group" "rg_module_vnet" {
  name     = "rg-module-vnet"
  location = var.location
}

resource "azurerm_virtual_network" "vnet_module" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_module_vnet.name
  address_space       = var.vnet_cidr
}
