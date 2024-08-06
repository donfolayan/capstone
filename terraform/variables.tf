# variables.tf

variable "client_id" {
  description = "The client ID for the Azure Service Principal."
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "The client secret for the Azure Service Principal."
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "The subscription ID for the Azure account."
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "The tenant ID for the Azure account."
  type        = string
  sensitive   = true
}
