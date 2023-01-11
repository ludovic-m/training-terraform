resource "azurerm_network_interface" "nic_training" {
  name                = "nic-training"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_training.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet_training.id
    private_ip_address            = cidrhost(element(azurerm_subnet.subnet_training.address_prefixes, 0), 10)
    private_ip_address_allocation = "Static"
  }
}
