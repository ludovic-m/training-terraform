resource "azurerm_network_interface" "nic_training" {
  count               = var.nb_vm
  name                = "nic-${terraform.workspace}-training-${count.index + 1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_training.name

  ip_configuration {
    name                          = "ipconfig-${terraform.workspace}-${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnet_training.id
    private_ip_address            = cidrhost(element(azurerm_subnet.subnet_training.address_prefixes, 0), 10 + count.index)
    private_ip_address_allocation = "Static"
  }
}
