variable "namespace" {
  description = "Kubernetes namespace for the Ingress controller"
  type        = string
  default     = "ingress-nginx"
}

variable "ingress_class_name" {
  description = "Name of the Ingress class"
  type        = string
  default     = "nginx"
} 