output "id" {
  description = "Resource ID of the Azure AI Foundry hub."
  value       = azurerm_ai_foundry.this.id
}

output "name" {
  description = "Name of the hub."
  value       = azurerm_ai_foundry.this.name
}

output "location" {
  description = "Hub location."
  value       = azurerm_ai_foundry.this.location
}

output "resource_group_name" {
  description = "The resource group where the hub resides."
  value       = azurerm_ai_foundry.this.resource_group_name
}

# Identity details are present when SystemAssigned or UserAssigned is configured
output "identity_principal_id" {
  description = "MSI principal ID (if SystemAssigned)."
  value       = try(azurerm_ai_foundry.this.identity[0].principal_id, null)
}

output "identity_tenant_id" {
  description = "MSI tenant ID (if SystemAssigned)."
  value       = try(azurerm_ai_foundry.this.identity[0].tenant_id, null)
}
