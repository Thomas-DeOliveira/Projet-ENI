variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "mysql_server_name" {
  description = "Nom du serveur MySQL"
  type        = string
  default     = "mysql-flexible-projet-eni"
}

variable "mysql_admin_username" {
  description = "Nom d'utilisateur administrateur MySQL"
  type        = string
  default     = "adminmysql"
}

variable "mysql_subnet_id" {
  description = "ID du sous-réseau dédié pour MySQL"
  type        = string
}

variable "mysql_private_dns_zone_id" {
  description = "ID de la zone DNS privée pour MySQL"
  type        = string
}

variable "key_vault_id" {
  description = "ID du Key Vault pour stocker le mot de passe"
  type        = string
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default     = {}
}
