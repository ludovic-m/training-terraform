location = "West Europe"

vnet_address_space = ["10.1.0.0/16"]
subnet_prefix = ["10.1.1.0/24"]

vms = {
  vm01 = {
    name     = "frontend"
    ip_index = 0
  },
  vm02 = {
    name     = "backend"
    ip_index = 1
  }
}
