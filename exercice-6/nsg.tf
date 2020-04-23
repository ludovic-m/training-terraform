resource "azurerm_network_security_group" "nsg_training" {
  name                = "nsg-${terraform.workspace}-training"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_training.name
}