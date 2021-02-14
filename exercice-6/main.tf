terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "abcd1234"
    container_name       = "tfstate"
    key                  = "training.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  # subscription_id = ""
}

resource "azurerm_resource_group" "rg_training" {
  name     = "rg-${terraform.workspace}-training"
  location = var.location
}
