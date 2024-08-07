terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.67.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  required_version = ">= 0.14"
}

provider "azurerm" {
  features {}
}

provider "random" {}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

data "azurerm_key_vault" "keyvault" {
  name                = "sockshop"
  resource_group_name = "sockshop_capstone-rg"
}

data "azurerm_key_vault_secret" "client_id" {
  name         = "client-id"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "password" {
  name         = "password"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# Generate a random integer for unique resource naming
resource "random_integer" "num" {
  min = 10
  max = 100
}

# Resource Group
# resource "azurerm_resource_group" "rg" {
#   name     = "sockshop_capstone-rg"
#   location = "East US 2"

#   tags = {
#     environment = "capstone_project"
#   }
# }

# Network Security Group
resource "azurerm_network_security_group" "capstone-nsg" {
  name                = "capstone-security-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Define security rules here if needed
}

# Virtual Network
resource "azurerm_virtual_network" "capstone-network" {
  name                = "capstone-${random_integer.num.id}-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.capstone-nsg.id
  }

  tags = {
    environment = "capstone_project"
  }
}

# Azure Kubernetes Service
resource "azurerm_kubernetes_cluster" "capstone-aks" {
  name                = "capstone-${random_integer.num.id}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${random_integer.num.id}-k8s"
  kubernetes_version  = "1.28.10"

  default_node_pool { 
    name            = "nodepool1"
    node_count      = 2
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = data.azurerm_key_vault_secret.client_id.value
    client_secret = data.azurerm_key_vault_secret.password.value
  }

  role_based_access_control_enabled = true

  tags = {
    environment = "capstone_project"
  }
}