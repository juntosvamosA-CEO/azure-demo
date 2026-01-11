variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "azure-demo-rg"
}

variable "location" {
  description = "The Azure region to deploy to"
  default     = "West Europe"
}

variable "prefix" {
  description = "A prefix for resources"
  default     = "az-demo"
}
