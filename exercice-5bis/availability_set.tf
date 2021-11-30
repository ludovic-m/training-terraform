resource "azurerm_availability_set" "as_training" {
  name                = "as-${terraform.workspace}-training"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_training.name
  managed             = true
}