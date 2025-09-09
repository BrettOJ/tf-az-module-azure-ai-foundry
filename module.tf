

resource "azurerm_ai_foundry" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Required per provider docs/snippets
  storage_account_id  = var.storage_account_id

  # Optional: supported by provider; safe to leave null if unused
  key_vault_id        = var.key_vault_id

  # Optional tags
  tags = var.tags

  # Dynamic block for identity (SystemAssigned or UserAssigned)
  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]
    content {
      # "SystemAssigned" | "UserAssigned" | "SystemAssigned, UserAssigned"
      type = identity.value.type

      # For UserAssigned, pass one or more IDs; for SystemAssigned leave empty list
      identity_ids = try(identity.value.identity_ids, [])
    }
  }

  lifecycle {
    # Helpful while you iterate
    ignore_changes = [
      tags,
    ]
  }
}
