resource "azurerm_virtual_network" "vnet_training" {
  name                = "vnet-training"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_training.name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnet_training" {
  name                 = "subnet-training"
  resource_group_name  = azurerm_resource_group.rg_training.name
  virtual_network_name = azurerm_virtual_network.vnet_training.name
  address_prefixes     = var.subnet_prefix
}
