variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "vnet_name" {
  description = "Nom du réseau virtuel"
  type        = string
  default     = "aks-vnet"
}

variable "vnet_address_space" {
  description = "Plage d'adresses du VNet"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "subnet_name" {
  description = "Nom du sous-réseau pour AKS"
  type        = string
  default     = "aks-subnet"
}

variable "subnet_address_prefix" {
  description = "Plage d'adresses du sous-réseau"
  type        = list(string)
  default     = ["10.1.0.0/24"]
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default     = {}
}