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
  default     = "mysql-projet-eni"
}

variable "mysql_admin_username" {
  description = "Nom d'utilisateur administrateur MySQL"
  type        = string
  default     = "adminmysql"
}

variable "mysql_admin_password" {
  description = "Mot de passe administrateur MySQL"
  type        = string
  sensitive   = true
}

variable "mysql_sku_name" {
  description = "SKU du serveur MySQL (ex: B_Gen5_2)"
  type        = string
  default     = "B_Gen5_2"
}

variable "mysql_version" {
  description = "Version de MySQL"
  type        = string
  default     = "5.7"
}

variable "mysql_storage_mb" {
  description = "Taille du stockage en Mo"
  type        = number
  default     = 51200 # 50 Go
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default     = {}
}
