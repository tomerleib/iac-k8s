output "namespace" {
  description = "The namespace where the Ingress controller is deployed"
  value       = kubernetes_namespace.ingress.metadata[0].name
}

output "ingress_class_name" {
  description = "The name of the Ingress class"
  value       = var.ingress_class_name
} 