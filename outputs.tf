output "applications" {
  description = "Map of all deployed applications"
  value = {
    web_app = {
      namespace     = module.web_app.namespace
      service_name  = module.web_app.service_name
      ingress_path  = var.applications.web_app.ingress_path
      ingress_host  = var.ingress_host
    }
    api_service = {
      namespace     = module.api_service.namespace
      service_name  = module.api_service.service_name
      ingress_path  = var.applications.api_service.ingress_path
      ingress_host  = var.ingress_host
    }
    dashboard = {
      namespace     = module.dashboard.namespace
      service_name  = module.dashboard.service_name
      ingress_path  = var.applications.dashboard.ingress_path
      ingress_host  = var.ingress_host
    }
  }
}

output "access_instructions" {
  description = "Instructions for accessing each application using port-forward"
  value = [
    "To access web app, run: kubectl port-forward -n web-app svc/web-app 8080:80",
    "Then visit: http://localhost:8080",
    "",
    "To access API service, run: kubectl port-forward -n api svc/api-service 8081:80",
    "Then visit: http://localhost:8081",
    "",
    "To access dashboard, run: kubectl port-forward -n dashboard svc/dashboard 8082:80",
    "Then visit: http://localhost:8082"
  ]
}
