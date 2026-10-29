variable "location" {
  description = "Azure region for the Hub landing zone"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the central connectivity resource group"
  type        = string
  default     = "rg-platform-connectivity-prod-001"
}

variable "hub_address_space" {
  description = "CIDR block for the Central Hub VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Governance tags"
  type        = map(string)
  default = {
    Environment = "Platform-Connectivity"
    Framework   = "Microsoft-CAF"
    ManagedBy   = "Terraform"
    Owner       = "Ashwani Jaiswal"
  }
}
