provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

terraform {
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "abcd1234"
    container_name       = "tfstate"
    key                  = "training.terraform.tfstate"
  }
}

# Snippet tf-azurerm_resource_group
resource "azurerm_resource_group" "rg_training" {
  name     = "rg-${terraform.workspace}-training"
  location = var.location
}
