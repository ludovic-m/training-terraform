provider "azurerm" {
  features {}
 }
 
resource "azurerm_resource_group" "rg_training" {
  name     = "rg-training"
  location = "West Europe"
}
