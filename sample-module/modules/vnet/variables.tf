variable "vnet_name" {
  type = string
}

variable "vnet_cidr" {
  type = list(string)
}

variable "location" {
  type = string
  default = "West Europe"
}