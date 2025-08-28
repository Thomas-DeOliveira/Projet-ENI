# Génération d'un mot de passe aléatoire
resource "random_password" "mysql_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Stockage du mot de passe dans le Key Vault
resource "azurerm_key_vault_secret" "mysql_password" {
  name         = "mysql-flexible-admin-password"
  value        = random_password.mysql_password.result
  key_vault_id = var.key_vault_id
}

# Création du MySQL Flexible Server avec un endpoint privé
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = var.mysql_server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.mysql_admin_username
  administrator_password = random_password.mysql_password.result
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"
  storage {
    size_gb = 20
  }
  delegated_subnet_id    = var.mysql_subnet_id
  private_dns_zone_id     = var.mysql_private_dns_zone_id
}

resource "azurerm_mysql_flexible_server_configuration" "secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_mysql_flexible_server.mysql.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = "OFF"
}

# Création de la base de données todolist_db
resource "azurerm_mysql_flexible_database" "todolist" {
  name                = "todolist_db"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_general_ci"

  lifecycle {
    ignore_changes = [charset, collation]
  }
}
