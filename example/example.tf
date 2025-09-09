terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.19.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ----------- Prereqs -----------
resource "azurerm_resource_group" "rg" {
  name     = "rg-ai-foundry-demo-001"
  location = "Southeast Asia"
}

# SA names must be globally unique, 3-24 chars, lowercase only
resource "random_id" "sa" {
  byte_length = 4
}

resource "azurerm_storage_account" "hub_sa" {
  name                     = "aifndry${random_id.sa.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"

}

# (Optional) If you want to attach a Key Vault to the hub, uncomment this block
# and pass key_vault_id into the module call below.
#
# data "azurerm_client_config" "current" {}
#
# resource "random_id" "kv" {
#   byte_length = 3
# }
#
# resource "azurerm_key_vault" "hub_kv" {
#   name                        = "kv-aif${random_id.kv.hex}"
#   location                    = azurerm_resource_group.rg.location
#   resource_group_name         = azurerm_resource_group.rg.name
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   sku_name                    = "standard"
#   soft_delete_retention_days  = 7
#   purge_protection_enabled    = false
#   enable_rbac_authorization   = true
#   public_network_access_enabled = true
#
#   network_acls {
#     default_action = "Allow"
#     bypass         = "AzureServices"
#   }
# }

# ----------- Module Call -----------
module "ai_foundry_hub" {
  # Point this to your module location
  source = "./modules/ai-foundry"

  name                = "aihub-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  storage_account_id  = azurerm_storage_account.hub_sa.id

  # Uncomment to link a KV created above
  # key_vault_id        = azurerm_key_vault.hub_kv.id

  # Identity examples:
  # System-assigned MSI
  identity = {
    type = "SystemAssigned"
  }

  # Or, for user-assigned MSI:
  # identity = {
  #   type         = "UserAssigned"
  #   identity_ids = ["/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<name>"]
  # }

  tags = {
    env = "demo"
  }
}
