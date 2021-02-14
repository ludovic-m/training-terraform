terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


provider "azurerm" {
  features {}
 }

resource "azurerm_resource_group" "rg_training" {
   name = "rg-${terraform.workspace}-training"
   location = var.location
}