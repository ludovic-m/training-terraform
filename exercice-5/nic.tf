variable "nic_coding_dojo_name" {
  default = "nic_coding_dojo"
}

variable "nic_private_ip" {
  type = "list"
}

variable "nic_coding_dojo_ip_name" {
  default = "nic_coding_dojo_ip"
}

resource "azurerm_network_interface" "nic_coding_dojo" {
  count               = "${length(var.nic_private_ip)}"
  name                = "${var.nic_coding_dojo_name}_${count.index+1}"
  resource_group_name = "${azurerm_resource_group.rg_coding_dojo.name}"
  location            = "${var.location}"

  ip_configuration {
    name                          = "${var.nic_coding_dojo_ip_name}_${count.index+1}"
    subnet_id                     = "${azurerm_subnet.subnet_coding_dojo.id}"
    private_ip_address            = "${element(var.nic_private_ip, count.index)}"
    private_ip_address_allocation = "Static"
  }
}
