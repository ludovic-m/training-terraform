provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "rg_coding_dojo" {
  name     = "rg_${terraform.workspace}_coding_dojo"
  location = "${var.location}"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg_terraform"
    storage_account_name = "lmeterraform"
    container_name       = "tfstate"
    key                  = "dojo.terraform.tfstate"
  }
}
