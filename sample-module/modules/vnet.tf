resource "azurerm_virtual_network" "vnet_training" {
  name                = "vnet-${terraform.workspace}-training"
  location            = "West Europe"
  address_space       = var.vnet_address_space
  resource_group_name = azurerm_resource_group.rg_training.name
}

resource "azurerm_subnet" "subnet_training" {
  name                 = "subnet-training"
  virtual_network_name = azurerm_virtual_network.vnet_training.name
  resource_group_name  = azurerm_virtual_network.vnet_training.resource_group_name
  address_prefixes     = var.subnet_prefix
}
