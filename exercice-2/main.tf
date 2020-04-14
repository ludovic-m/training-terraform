provider "azurerm" {}

resource "azurerm_resource_group" "rg_training" {
  name     = "rg-training"
  location = "West Europe"
}
