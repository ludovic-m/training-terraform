variable "nic_private_ip" {
  type = "list"
}

resource "azurerm_network_interface" "nic_coding_dojo" {
  count               = "${length(var.nic_private_ip)}"
  name                = "nic_${terraform.workspace}_coding_dojo_${count.index+1}"
  resource_group_name = "${azurerm_resource_group.rg_coding_dojo.name}"
  location            = "${var.location}"

  ip_configuration {
    name                          = "nic_${terraform.workspace}_coding_dojo_ip_${count.index+1}"
    subnet_id                     = "${azurerm_subnet.subnet_coding_dojo.id}"
    private_ip_address            = "${element(var.nic_private_ip, count.index)}"
    private_ip_address_allocation = "Static"
  }
}
