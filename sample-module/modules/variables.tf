variable "location" {
  default = "West Europe"
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_prefix" {
  type = list(string)
}

variable "nb_vm" {
  default = 2
}

variable "vms" {
  type = map(object({
    name  = string
    ip_index = number
    }
  ))
}
