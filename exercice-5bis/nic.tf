resource "azurerm_network_interface" "nic_training" {
  for_each            = var.vms
  name                = "nic-${terraform.workspace}-training-${each.value.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_training.name

  ip_configuration {
    name                          = "ipconfig-${terraform.workspace}-${each.value.ip_index}"
    subnet_id                     = azurerm_subnet.subnet_training.id
    private_ip_address            = cidrhost(element(azurerm_subnet.subnet_training.address_prefixes, 0), 10 + each.value.ip_index)
    private_ip_address_allocation = "Static"
  }
}
