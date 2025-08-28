data "azurerm_resource_group" "rg" {
  name = "rg-projet-eni"
}

data "azurerm_client_config" "current" {}

module "network" {
  source                = "./modules/network"
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  tags = {
    user = "TDeOliveira2024"
  }
}

module "aks" {
  source                = "./modules/aks"
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  subnet_id             = module.network.subnet_id
  tags = {
    user = "TDeOliveira2024"
  }
}

module "keyvault" {
  source                = "./modules/keyvault"
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  tenant_id             = data.azurerm_client_config.current.tenant_id
  object_id             = data.azurerm_client_config.current.object_id
  aks_mi_principal_id = module.aks.aks_mi_principal_id
  tags = {
    user = "TDeOliveira2024"
  }
}

module "mysql" {
  source                     = "./modules/mysql"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location
  mysql_subnet_id            = module.network.mysql_subnet_id
  mysql_private_dns_zone_id   = module.network.mysql_private_dns_zone_id
  key_vault_id               = module.keyvault.key_vault_id
  tags = {
    user = "TDeOliveira2024"
  }
}
