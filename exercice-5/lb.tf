resource "azurerm_network_security_rule" "nsg_rule_training" {
  name                        = "nsg-rule-${terraform.workspace}-training"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_training.name
  network_security_group_name = azurerm_network_security_group.nsg_training.name
}

resource "azurerm_public_ip" "pip_training" {
  name                = "pip-${terraform.workspace}-training"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_training.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb_training" {
  name                = "lb-${terraform.workspace}-training"
  location            = azurerm_resource_group.rg_training.location
  resource_group_name = azurerm_resource_group.rg_training.name

  frontend_ip_configuration {
    name                 = "primary"
    public_ip_address_id = azurerm_public_ip.pip_training.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool_training" {
  loadbalancer_id = azurerm_lb.lb_training.id
  name            = "lb-pool-${terraform.workspace}-training"
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_backend_assoc_training" {
  count                   = var.nb_vm
  network_interface_id    = azurerm_network_interface.nic_training[count.index].id
  ip_configuration_name   = "ipconfig-${terraform.workspace}-${count.index + 1}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool_training.id
}

resource "azurerm_lb_probe" "lb_probe_training" {
  resource_group_name = azurerm_resource_group.rg_training.name
  loadbalancer_id     = azurerm_lb.lb_training.id
  name                = "tcp-running-${terraform.workspace}-probe"
  port                = 80
}

resource "azurerm_lb_rule" "lb_rule_training" {
  resource_group_name            = azurerm_resource_group.rg_training.name
  loadbalancer_id                = azurerm_lb.lb_training.id
  name                           = "lb-rule-${terraform.workspace}"
  protocol                       = "Tcp"
  frontend_port                  = 80
  frontend_ip_configuration_name = "primary"
  backend_port                   = 80
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_pool_training.id]
  probe_id                       = azurerm_lb_probe.lb_probe_training.id
}