output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.capstone-aks.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.capstone-aks.kube_admin_config
  sensitive = true
}