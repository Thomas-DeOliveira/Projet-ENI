output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  value = azurerm_subnet.aks.id
}

output "mysql_subnet_id" {
  value = azurerm_subnet.mysql.id
}

output "mysql_private_dns_zone_id" {
  value = azurerm_private_dns_zone.mysql.id
}
