terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.98.0"
    }
  }
}

provider "azurerm" {
  features {}

  # subscription_id = ""
}

resource "azurerm_resource_group" "rg_training" {
  name     = "rg-training"
  location = "West Europe"
}
