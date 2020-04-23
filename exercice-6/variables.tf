variable "location" {
  default = "West Europe"
}

variable "vnet_address_space" {
  type = "list"
}

variable "subnet_prefix" {
  type = "string"
}

variable "nb_vm" {
  default = 2
}

variable "subscription_id" { }
variable "client_id" { }
variable "client_secret" { }
variable "tenant_id" { }