terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}
provider "azurerm" {
  features {}
  use_cli = true
  subscription_id = "ca5c57dd-3aab-4628-a78c-978830d03bbd"
}
