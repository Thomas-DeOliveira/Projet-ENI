resource "azurerm_mysql_server" "mysql" {
  name                = var.mysql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  administrator_login          = var.mysql_admin_username
  administrator_login_password = var.mysql_admin_password

  sku_name   = var.mysql_sku_name
  version    = var.mysql_version
  storage_mb = var.mysql_storage_mb

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  tags = var.tags
}

resource "azurerm_mysql_firewall_rule" "allow_azure" {
  name                = "AllowAzure"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
