variable "project_name" {
  description = "Name of the project used for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "australiaeast"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vm_admin_username" {
  description = "Admin username for the Linux VM"
  type        = string
}

variable "vm_admin_ssh_public_key_path" {
  description = "Path to SSH public key file for VM authentication"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B1s"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
