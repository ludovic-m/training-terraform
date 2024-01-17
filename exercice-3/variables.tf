variable "location" {
  default = "West Europe"
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_prefix" {
  type = list(string)
}