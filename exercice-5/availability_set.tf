variable "as_coding_dojo_name" {
  default = "as_coding_dojo"
}

resource "azurerm_availability_set" "as_coding_dojo" {
  name                = "${var.as_coding_dojo_name}"
  resource_group_name = "${azurerm_resource_group.rg_coding_dojo.name}"
  location            = "${var.location}"
  managed             = "true"
}
