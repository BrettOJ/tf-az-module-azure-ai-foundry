variable "name" {
  description = "Name of the Azure AI Foundry (hub) resource."
  type        = string
}

variable "location" {
  description = "Azure region for the hub."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the hub will be created."
  type        = string
}

variable "storage_account_id" {
  description = "Resource ID of the Storage Account associated with the hub."
  type        = string
}

variable "key_vault_id" {
  description = "Optional Key Vault resource ID for the hub (if applicable)."
  type        = string
  default     = null
}

variable "identity" {
  description = <<-EOT
    Optional identity configuration for the hub.
    Example for SystemAssigned:
      {
        type = "SystemAssigned"
      }

    Example for UserAssigned:
      {
        type         = "UserAssigned"
        identity_ids = ["/subscriptions/.../resourceGroups/.../providers/Microsoft.ManagedIdentity/userAssignedIdentities/ua-mi"]
      }
  EOT
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "tags" {
  description = "Optional tags to apply to the hub."
  type        = map(string)
  default     = {}
}
