# Kind cluster variables
variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
  default     = "terraform-kind"
}

variable "worker_nodes" {
  description = "Number of worker nodes to create"
  type        = number
  default     = 2
}

variable "node_port" {
  description = "Port to expose on the host machine"
  type        = number
  default     = 80
}

variable "ingress_host" {
  description = "Host for the Ingress resources"
  type        = string
  default     = "localhost"
}

# Application Ports Configuration
variable "application_ports" {
  description = "Port configuration for different application types"
  type = object({
    web = object({
      container_port = number
      service_port   = number
    })
    api = object({
      container_port = number
      service_port   = number
    })
    dashboard = object({
      container_port = number
      service_port   = number
    })
  })
  default = {
    web = {
      container_port = 8080
      service_port   = 80
    }
    api = {
      container_port = 8080
      service_port   = 80
    }
    dashboard = {
      container_port = 8080
      service_port   = 80
    }
  }
}

# Application Resource Configuration
variable "application_resources" {
  description = "Resource configuration for different application types"
  type = object({
    web = object({
      cpu_limit    = string
      memory_limit = string
      cpu_request  = string
      memory_request = string
    })
    api = object({
      cpu_limit    = string
      memory_limit = string
      cpu_request  = string
      memory_request = string
    })
    dashboard = object({
      cpu_limit    = string
      memory_limit = string
      cpu_request  = string
      memory_request = string
    })
  })
  default = {
    web = {
      cpu_limit     = "200m"
      memory_limit  = "256Mi"
      cpu_request   = "100m"
      memory_request = "128Mi"
    }
    api = {
      cpu_limit     = "300m"
      memory_limit  = "512Mi"
      cpu_request   = "150m"
      memory_request = "256Mi"
    }
    dashboard = {
      cpu_limit     = "500m"
      memory_limit  = "1Gi"
      cpu_request   = "250m"
      memory_request = "512Mi"
    }
  }
}

# Application Configuration
variable "applications" {
  description = "Configuration for all applications"
  type = map(object({
    name             = string
    namespace        = string
    replica_count    = number
    image            = string
    ingress_path     = string
    app_type         = string
  }))
  default = {
    web_app = {
      name          = "web-app"
      namespace     = "web-app"
      replica_count = 3
      image         = "gcr.io/google-samples/hello-app:1.0"
      ingress_path  = "/web"
      app_type      = "web"
    }
    api_service = {
      name          = "api-service"
      namespace     = "api"
      replica_count = 2
      image         = "gcr.io/google-samples/hello-app:1.0"
      ingress_path  = "/api"
      app_type      = "api"
    }
    dashboard = {
      name          = "dashboard"
      namespace     = "dashboard"
      replica_count = 1
      image         = "gcr.io/google-samples/hello-app:1.0"
      ingress_path  = "/dashboard"
      app_type      = "dashboard"
    }
  }
} 