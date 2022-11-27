terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.98.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "lmetftraining"
    container_name       = "tfstate"
    key                  = "training.terraform"
  }
}

provider "azurerm" {
  features {}

  # subscription_id = ""
}

resource "azurerm_resource_group" "rg_training" {
  name     = "rg-${terraform.workspace}-training"
  location = "West Europe"
}

module "additional_vnet_module" {
  source = "./modules/vnet"

  vnet_name = "vnet-module-training"
  vnet_cidr = ["10.10.0.0/16"]
}