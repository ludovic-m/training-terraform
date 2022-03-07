resource "azurerm_network_security_group" "nsg_training" {
  name                = "nsg-${terraform.workspace}-training"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_training.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_training" {
  subnet_id                 = azurerm_subnet.subnet_training.id
  network_security_group_id = azurerm_network_security_group.nsg_training.id
}
