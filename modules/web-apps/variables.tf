variable "app_name" {
  description = "Name of the application (for backward compatibility)"
  type        = string
}

variable "name" {
  description = "Name of the application"
  type        = string
}

variable "namespace" {
  description = "Namespace where the application will be deployed"
  type        = string
}

variable "replica_count" {
  description = "Number of replicas to deploy"
  type        = number
  default     = 1
}

variable "container_port" {
  description = "Port the container is listening on"
  type        = number
  default     = 8080
}

variable "service_port" {
  description = "Port the service is exposing"
  type        = number
  default     = 80
}

variable "resource_limits" {
  description = "Resource limits for the containers"
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "200m"
    memory = "256Mi"
  }
}

variable "resource_requests" {
  description = "Resource requests for the containers"
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "100m"
    memory = "128Mi"
  }
}

variable "image" {
  description = "Docker image to use for the application"
  type        = string
}

variable "ingress_path" {
  description = "Path for the Ingress resource"
  type        = string
}

variable "ingress_host" {
  description = "Host for the Ingress resource"
  type        = string
  default     = "localhost"
}

variable "ingress_class_name" {
  description = "Name of the Ingress class to use"
  type        = string
  default     = "nginx"
}

variable "app_type" {
  description = "Type of application (web, api, dashboard)"
  type        = string
}

variable "app_config" {
  description = "Additional configuration for the application"
  type = object({
    environment_variables = optional(map(string), {})
    command              = optional(list(string), [])
    args                 = optional(list(string), [])
    volume_mounts       = optional(list(object({
      name      = string
      mount_path = string
    })), [])
    volumes            = optional(list(object({
      name = string
      config_map_name = string
    })), [])
  })
  default = {}
} 