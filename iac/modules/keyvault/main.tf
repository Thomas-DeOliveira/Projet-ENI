resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  enabled_for_disk_encryption = false
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Purge"
    ]
  }

  tags = var.tags
}
