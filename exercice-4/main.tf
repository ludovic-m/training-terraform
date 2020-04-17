provider "azurerm" {
  features {}
 }

resource "azurerm_resource_group" "rg_coding_dojo" {
  name     = "rg_${terraform.workspace}_coding_dojo"
  location = "${var.location}"
}
