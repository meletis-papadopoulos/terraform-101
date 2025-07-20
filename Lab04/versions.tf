terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-dev"
    storage_account_name = "sthvh4qez2hs"
    container_name       = "tfstate"
    key                  = "devops-dev"
  }
}

provider "azurerm" {
  # Configuration options
  features {
    # Delete non-empty RG
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    # KeyVault
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }

  # Azure Subscription ID
  subscription_id = var.subscription_id
}
