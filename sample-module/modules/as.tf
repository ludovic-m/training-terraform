resource "azurerm_availability_set" "as_training" {
  name                = "as-${terraform.workspace}-training"
  resource_group_name = azurerm_resource_group.rg_training.name
  location            = var.location
  managed             = true
}
