# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

# Random string suffix
resource "random_string" "keyvault_suffix" {
  length  = 6
  upper   = false
  special = false
}

# Data source to access the configuration of AzureRM provider
data "azurerm_client_config" "current" {}

# Azure KeyVault
resource "azurerm_key_vault" "main" {
  name                      = "kv-${var.application_name}-${var.environment_name}-${random_string.keyvault_suffix.result}"
  location                  = azurerm_resource_group.main.location
  resource_group_name       = azurerm_resource_group.main.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled  = false
  sku_name                  = "standard"
  enable_rbac_authorization = true
  # soft_delete_retention_days = 7
}

# Role Assignment for KeyVault using TF current identity as principal
resource "azurerm_role_assignment" "terraform_user" {
  scope                = azurerm_key_vault.main.id                    # Context in which a particular identity has particular permissions
  role_definition_name = "Key Vault Administrator"                    # Built-in role definitions that contain a collection of permissions to grant to identity
  principal_id         = data.azurerm_client_config.current.object_id # Pointer to identity (human or machine) to grant permissions to
}

# Access information about an existing Log Analytics Workspace
data "azurerm_log_analytics_workspace" "observability" {
  name                = "log-observability-dev"
  resource_group_name = "rg-observability-dev"
}


# Manage a Diagnostic Setting for an existing Resource (i.e. KeyVault)
resource "azurerm_monitor_diagnostic_setting" "main" {
  name               = "diag-${var.application_name}-${var.environment_name}-${random_string.keyvault_suffix.result}"
  target_resource_id = azurerm_key_vault.main.id

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.observability.id

  enabled_log {
    category_group = "audit"
  }

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

# Reference: https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations
