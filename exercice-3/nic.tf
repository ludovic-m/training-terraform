
variable "nic_private_ip" {
  default = "10.0.1.4"
}

resource "azurerm_network_interface" "nic_coding_dojo" {
  name                = "nic_coding_dojo"
  resource_group_name = "${azurerm_resource_group.rg_coding_dojo.name}"
  location            = "${var.location}"

  ip_configuration {
    name                          = "nic_coding_dojo_ip"
    subnet_id                     = "${azurerm_subnet.subnet_coding_dojo.id}"
    private_ip_address            = "${var.nic_private_ip}"
    private_ip_address_allocation = "Static"
  }
}
