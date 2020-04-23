resource "azurerm_virtual_network" "vnet_training" {
   name = "vnet-${terraform.workspace}-training"
   location = var.location
   resource_group_name = azurerm_resource_group.rg_training.name
   address_space = var.vnet_address_space
}

resource "azurerm_subnet" "subnet_training" {
   name = "subnet-training"
   resource_group_name = azurerm_resource_group.rg_training.name
   virtual_network_name = azurerm_virtual_network.vnet_training.name
   address_prefix = var.subnet_prefix
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_training" {
  subnet_id                 = azurerm_subnet.subnet_training.id
  network_security_group_id = azurerm_network_security_group.nsg_training.id
}