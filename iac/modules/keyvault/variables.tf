variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "key_vault_name" {
  description = "Nom du Key Vault"
  type        = string
  default     = "kv-projet-eni"
}

variable "tenant_id" {
  description = "ID du tenant Azure"
  type        = string
}

variable "object_id" {
  description = "ID de l'objet (utilisateur, identité, etc.) pour les permissions"
  type        = string
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default     = {}
}
