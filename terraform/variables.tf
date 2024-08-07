variable "client_id" {
  description = "Azure Kubernetes Service Cluster service principal"
  type = string
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
  type = string
}

variable "keyvault_id" {
  description = "The ID of the Azure Key Vault"
  type        = string
}