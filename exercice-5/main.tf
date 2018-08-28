provider "azurerm" {}

variable "rg_coding_dojo_name" {
  default = "rg_coding_dojo"
}

resource "azurerm_resource_group" "rg_coding_dojo" {
  name     = "${var.rg_coding_dojo_name}"
  location = "${var.location}"
}
