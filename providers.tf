terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestorageaccount"
    container_name       = "tfstate"
    key                  = "linux-vm-${var.environment}.tfstate"
  }
}

provider "azurerm" {
  features {}
}
