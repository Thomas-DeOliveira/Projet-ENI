data "azurerm_resource_group" "rg" {
  name = "rg-TDeOliveira2024_cours-projet"
}

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
