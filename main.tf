terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Create the Kind cluster first
module "kind" {
  source = "./modules/kind"

  cluster_name = var.cluster_name
  worker_nodes = var.worker_nodes
  node_port   = var.node_port
}

# Configure providers after the cluster is created
provider "kubernetes" {
  config_path = module.kind.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = module.kind.kubeconfig_path
  }
}

# Rest of the modules depend on the cluster and providers
module "ingress" {
  source = "./modules/ingress"

  namespace         = "ingress-nginx"
  ingress_class_name = "nginx"

  depends_on = [module.kind]
}

module "web_app" {
  source = "./modules/web-apps"

  app_name          = var.applications.web_app.name
  name              = var.applications.web_app.name
  namespace         = var.applications.web_app.namespace
  replica_count     = var.applications.web_app.replica_count
  image             = var.applications.web_app.image
  container_port    = var.application_ports.web.container_port
  service_port      = var.application_ports.web.service_port
  resource_limits   = {
    cpu    = var.application_resources.web.cpu_limit
    memory = var.application_resources.web.memory_limit
  }
  resource_requests = {
    cpu    = var.application_resources.web.cpu_request
    memory = var.application_resources.web.memory_request
  }
  ingress_path      = var.applications.web_app.ingress_path
  ingress_class_name = "nginx"
  app_type          = var.applications.web_app.app_type

  depends_on = [module.ingress]
}

module "api_service" {
  source = "./modules/web-apps"

  app_name          = var.applications.api_service.name
  name              = var.applications.api_service.name
  namespace         = var.applications.api_service.namespace
  replica_count     = var.applications.api_service.replica_count
  image             = var.applications.api_service.image
  container_port    = var.application_ports.api.container_port
  service_port      = var.application_ports.api.service_port
  resource_limits   = {
    cpu    = var.application_resources.api.cpu_limit
    memory = var.application_resources.api.memory_limit
  }
  resource_requests = {
    cpu    = var.application_resources.api.cpu_request
    memory = var.application_resources.api.memory_request
  }
  ingress_path      = var.applications.api_service.ingress_path
  ingress_class_name = "nginx"
  app_type          = var.applications.api_service.app_type

  depends_on = [module.ingress]
}

module "dashboard" {
  source = "./modules/web-apps"

  app_name          = var.applications.dashboard.name
  name              = var.applications.dashboard.name
  namespace         = var.applications.dashboard.namespace
  replica_count     = var.applications.dashboard.replica_count
  image             = var.applications.dashboard.image
  container_port    = var.application_ports.dashboard.container_port
  service_port      = var.application_ports.dashboard.service_port
  resource_limits   = {
    cpu    = var.application_resources.dashboard.cpu_limit
    memory = var.application_resources.dashboard.memory_limit
  }
  resource_requests = {
    cpu    = var.application_resources.dashboard.cpu_request
    memory = var.application_resources.dashboard.memory_request
  }
  ingress_path      = var.applications.dashboard.ingress_path
  ingress_class_name = "nginx"
  app_type          = var.applications.dashboard.app_type

  depends_on = [module.ingress]
} 