terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.1"
    }
  }
  required_version = ">= 1.12.2" 

  # if you want to have remote state management uncomment this 

  # backend "azurerm" {
  #   resource_group_name  = "state_storage_rgroup"
  #   storage_account_name = "statestorageaccount"
  #   container_name       = "statestoragecontainer"
  #   key                  = "terraform.tfstate"
  # }
}

