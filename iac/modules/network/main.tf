resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "aks" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix

  depends_on = [azurerm_virtual_network.vnet]
}

# Sous-réseau dédié pour MySQL Flexible Server
resource "azurerm_subnet" "mysql" {
  name                 = var.mysql_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.mysql_subnet_address_prefix
  delegation {
    name = "mysql-delegation"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Zone DNS privée pour MySQL
resource "azurerm_private_dns_zone" "mysql" {
  name                = "mysql-private-dns-zone.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
}

# Lien entre la zone DNS privée et le VNet
resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name  = azurerm_private_dns_zone.mysql.name
  virtual_network_id     = azurerm_virtual_network.vnet.id
}
