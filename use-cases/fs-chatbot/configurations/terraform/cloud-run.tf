# cloud-run.tf

resource "google_cloud_run_service" "api_gateway" {
  name     = "api-gateway-fs-chatbot"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/api-gateway:latest"

        resources {
          limits = {
            cpu    = "1000m"
            memory = "512Mi"
          }
        }

        env {
          name  = "PROJECT_ID"
          value = var.project_id
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
