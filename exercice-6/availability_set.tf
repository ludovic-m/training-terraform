resource "azurerm_availability_set" "as_coding_dojo" {
  name                = "as_${terraform.workspace}_coding_dojo"
  resource_group_name = "${azurerm_resource_group.rg_coding_dojo.name}"
  location            = "${var.location}"
  managed             = "true"
}
