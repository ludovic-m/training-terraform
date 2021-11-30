resource "azurerm_virtual_network" "vnet_training" {
  name                = "vnet-training"
  location            = "West Europe"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg_training.name
}

resource "azurerm_subnet" "subnet_training" {
  name                 = "subnet-training"
  virtual_network_name = azurerm_virtual_network.vnet_training.name
  resource_group_name  = azurerm_virtual_network.vnet_training.resource_group_name
  address_prefixes     = ["10.0.1.0/24"]
}
