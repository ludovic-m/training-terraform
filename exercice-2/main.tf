provider "azurerm" {}

resource "azurerm_resource_group" "rg_coding_dojo" {
  name     = "rg_coding_dojo"
  location = "West Europe"
}
