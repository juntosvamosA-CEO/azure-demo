variable "location" {
  description = "The Azure region to deploy to"
  default     = "eastus"
}

variable "prefix" {
  description = "A prefix for resources to avoid naming collisions"
  default     = "avd-lab-02"
}

variable "admin_username" {
  description = "Local admin username for VMs"
  default     = "labadmin"
}

variable "admin_password" {
  description = "Local admin password for VMs (demo only, ideally secure/KV)"
  default     = "ChangeMe123!"
}

variable "domain_name" {
  description = "The domain name for Entra ID users (e.g., yourtenant.onmicrosoft.com)"
  # We will try to auto-detect or user must supply via CLI/tfvars if needed.
  # For now, we'll fetch current config in main or use a placeholder.
  default = "juntosvamosalem.onmicrosoft.com" 
  # Note: Ideally we look up the current tenant domain via data source if possible.
}
