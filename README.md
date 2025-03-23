# Kubernetes Infrastructure Automation with Terraform

The project demonstrates how to create a scalable Kubernetes infrastructure using Kind (Kubernetes in Docker) with Terraform.

## Key Features

- **Automated Cluster Management**
  - Local Kubernetes cluster provisioning using Kind
  - Configurable multi-node cluster setup
  - Automated Ingress controller deployment

- **Application Deployment**
  - Multi-application support (web, API, dashboard)
  - Configurable replica management
  - Resource limit enforcement
  - Health monitoring with probes
  - Environment variable management
  - Volume and ConfigMap support

- **Traffic Management**
  - Path-based routing with Ingress
  - Intelligent load distribution
  - Health-based pod selection
  - Multi-application hosting

## Prerequisites

You can use either of the following approaches to set up your development environment:

### Option 1: Manual Installation

Before starting, ensure you have the following tools installed:

- Terraform
- kubectl
- Docker
- Kind
- Helm

### Option 2: Nix Shell (Recommended)

This project includes a `shell.nix` file that provides a reproducible development environment with all required tools.

1. **Install Nix** (if not already installed):
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. **Enter the Development Shell**:
   ```bash
   nix-shell
   ```

The Nix shell includes additional useful tools:
- `jq` and `yq` for JSON/YAML processing
- `kubectx` for Kubernetes context management
- `k9s` for terminal UI to interact with Kubernetes clusters

## Project Structure

```
.
├── main.tf           # Main Terraform configuration
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── modules/
│   ├── kind/        # Kind cluster module
│   │   ├── main.tf  # Kind cluster configuration
│   │   └── variables.tf
│   ├── ingress/     # Ingress controller module
│   │   ├── main.tf  # Ingress controller configuration
│   │   └── variables.tf
│   └── web-app/     # Web application module
│       ├── main.tf  # Application configuration
│       ├── variables.tf
│       └── outputs.tf
└── README.md        # This file
```

## Configuration

### Cluster Configuration

The Kind cluster can be configured through variables in `variables.tf`:

```hcl
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
```

### Application Configuration

Applications are configured through the `applications` map variable. Each application supports:

- Resource limits and requests
- Replica count
- Environment variables
- Volume mounts
- Ingress path configuration

Example configuration:

```hcl
applications = {
  web_app = {
    name             = "web-app"
    namespace        = "web-app"
    replica_count    = 3
    container_port   = 8080
    service_port     = 80
    resource_limits = {
      cpu    = "200m"
      memory = "256Mi"
    }
    resource_requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
    image        = "gcr.io/google-samples/hello-app:1.0"
    ingress_path = "/web"
    app_type     = "web"
  }
}
```

## Implementation

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the Plan**
   ```bash
   terraform plan
   ```

4. **Deploy the Infrastructure**
   ```bash
   terraform apply
   ```

5. **Access Applications**
   Once deployed, applications are accessible at:
   - Web App: http://localhost/web
   - API Service: http://localhost/api
   - Dashboard: http://localhost/dashboard

6. **Verify Deployment**
   ```bash
   # Check pod status
   kubectl get pods -A

   # Verify services
   kubectl get svc -A

   # Review ingress configuration
   kubectl get ingress -A
   ```

## Adding Applications

To add a new application, extend the `applications` map in `variables.tf`:

```hcl
applications = {
  # ... existing applications ...
  new_app = {
    name             = "new-app"
    namespace        = "new-app"
    replica_count    = 2
    container_port   = 8080
    service_port     = 80
    resource_limits = {
      cpu    = "200m"
      memory = "256Mi"
    }
    resource_requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
    image        = "your-image:tag"
    ingress_path = "/new-app"
    app_type     = "custom"
    app_config = {
      environment_variables = {
        "CUSTOM_VAR" = "value"
      }
    }
  }
}
```

kubectl port-forward -n web-app svc/web-app 8080:80
kubectl port-forward -n api svc/api-service 8081:80
kubectl port-forward -n dashboard svc/dashboard 8082:80


