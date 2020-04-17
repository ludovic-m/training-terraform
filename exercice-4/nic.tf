resource "azurerm_network_interface" "nic_training" {
  name                = "nic-${terraform.workspace}-training"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_training.name

  ip_configuration {
    name                          = "ip-config-training"
    subnet_id                     = azurerm_subnet.subnet_training.id
    private_ip_address_allocation = "Dynamic"
  }
}