output "mysql_server_name" {
  value = azurerm_mysql_server.mysql.name
}

output "mysql_fqdn" {
  value = azurerm_mysql_server.mysql.fqdn
}

output "mysql_admin_username" {
  value = azurerm_mysql_server.mysql.administrator_login
}
