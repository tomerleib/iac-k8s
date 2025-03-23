terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.2.1"
    }
  }
}

resource "kind_cluster" "default" {
  name           = var.cluster_name
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      labels = {
        "ingress-ready" = "true"
      }
      extra_port_mappings {
        container_port = 80
        host_port      = 80
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        protocol       = "TCP"
      }
      # Keep the existing node_port mapping if needed
      # extra_port_mappings {
      #   container_port = var.node_port
      #   host_port      = var.node_port
      # }
    }

    dynamic "node" {
      for_each = range(var.worker_nodes)
      content {
        role = "worker"
      }
    }
  }
}

# Add a local file to store the kubeconfig in the root directory
output "kubeconfig_path" {
  value = kind_cluster.default.kubeconfig_path
}

# Output the cluster name
output "cluster_name" {
  value = kind_cluster.default.name
} 
