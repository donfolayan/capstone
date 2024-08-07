variable "client_id" {
  description = "Azure Kubernetes Service Cluster service principal"
  type = string
  default = "data.azurerm_key_vault_secret.client_id.value"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
  type = string
  default = "data.azurerm_key_vault_secret.password.value"
}

variable "keyvault_id" {
  description = "The ID of the Azure Key Vault"
  type        = string
  default = "data.azurerm_key_vault.keyvault.id"
}