resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
  }

  data = {
    "index.html" = <<-EOT
      <!DOCTYPE html>
      <html>
      <head>
        <title>${var.name}</title>
      </head>
      <body>
        <h1>${var.name}</h1>
        <p>Pod Name: $${POD_NAME}</p>
      </body>
      </html>
    EOT
  }

  depends_on = [var.namespace]
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          name  = var.name
          image = var.image

          port {
            container_port = var.container_port
            name          = "http"
          }

          env {
            name  = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }


          dynamic "env" {
            for_each = var.app_config.environment_variables
            content {
              name  = env.key
              value = env.value
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/usr/share/nginx/html"
          }

          dynamic "volume_mount" {
            for_each = var.app_config.volume_mounts
            content {
              name       = volume_mount.value.name
              mount_path = volume_mount.value.mount_path
            }
          }

          resources {
            limits = {
              cpu    = var.resource_limits.cpu
              memory = var.resource_limits.memory
            }

            requests = {
              cpu    = var.resource_requests.cpu
              memory = var.resource_requests.memory
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = var.container_port
            }
            initial_delay_seconds = 5
            period_seconds       = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.container_port
            }
            initial_delay_seconds = 5
            period_seconds       = 10
          }
        }

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.app_config.metadata[0].name
          }
        }

        dynamic "volume" {
          for_each = var.app_config.volume_mounts
          content {
            name = volume.value.name
            config_map {
              name = volume.value.config_map_name
            }
          }
        }
      }
    }
  }

  depends_on = [var.namespace]
}

resource "kubernetes_service" "app_service" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.name
    }

    port {
      port        = var.service_port
      target_port = var.container_port
    }

    type = "ClusterIP"
  }

  depends_on = [var.namespace]
}

resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name      = "${var.name}-ingress"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = var.ingress_class_name

    rule {
      host = var.ingress_host

      http {
        path {
          path      = var.ingress_path
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.app_service.metadata[0].name
              port {
                number = var.service_port
              }
            }
          }
        }
      }
    }
  }

  depends_on = [var.namespace]
} 