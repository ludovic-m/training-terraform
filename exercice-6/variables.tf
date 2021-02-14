variable "location" {
  default = "West Europe"
}

variable "vnet_address_space" {
  type = "list"
}

variable "subnet_prefix" {
  type = "list"
}

variable "nb_vm" {
  default = 2
}