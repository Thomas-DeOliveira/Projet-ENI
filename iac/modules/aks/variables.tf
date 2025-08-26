variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "cluster_name" {
  description = "Nom du cluster AKS"
  type        = string
  default     = "aks-projet-eni"
}

variable "dns_prefix" {
  description = "Préfixe DNS pour le cluster AKS"
  type        = string
  default     = "aks-projet-eni"
}

variable "subnet_id" {
  description = "ID du sous-réseau pour AKS"
  type        = string
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default     = {}
}
