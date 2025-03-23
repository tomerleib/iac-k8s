output "namespace" {
  description = "Namespace where the application is deployed"
  value       = var.namespace
}

output "service_name" {
  description = "Name of the service exposing the application"
  value       = kubernetes_service.app_service.metadata[0].name
}

output "deployment_name" {
  description = "Name of the deployment running the application"
  value       = kubernetes_deployment.app.metadata[0].name
}

output "replica_count" {
  description = "Number of replicas running"
  value       = kubernetes_deployment.app.spec[0].replicas
}

output "ingress_path" {
  description = "The path where the application is exposed"
  value       = var.ingress_path
}

output "ingress_host" {
  description = "The host where the application is exposed"
  value       = var.ingress_host
} 