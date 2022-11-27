vnet_address_space = ["10.0.0.0/16"]
subnet_prefix = ["10.0.0.0/24"]
nb_vm = 3

vms = {
  vm01 = {
    name     = "frontend"
    ip_index = 0
  },
  vm02 = {
    name     = "backend"
    ip_index = 1
  },
  vm03 = {
    name     = "database"
    ip_index = 2
  }
}
