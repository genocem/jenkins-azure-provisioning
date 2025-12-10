variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "private_key_file_path" {
  description = "The file path to the private key"
  type        = string
}
variable "public_key_file_path" {
  description = "The file path to the public key"
  type        = string
}
variable "vm_type"{
  description = "name of he size of the azure vm to provision"
  type= string
}