resource "azurerm_kubernetes_cluster" "k8s" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = var.cluster_name
  dns_prefix          = var.dns_prefix

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "default"
    vm_size    = "Standard_B2S"
    node_count = 2
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin = "azure"  # Utilisation d'Azure CNI
    network_policy = "calico"
    service_cidr   = "10.0.0.0/16"
    dns_service_ip = "10.0.0.10"
  }
}

resource "azurerm_user_assigned_identity" "aks_mi" {
  name                = "AKSIdentity"
  resource_group_name = var.resource_group_name
  location            = var.location
}
