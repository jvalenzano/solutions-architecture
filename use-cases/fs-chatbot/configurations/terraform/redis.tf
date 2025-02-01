# redis.tf

resource "google_redis_instance" "cache" {
  name           = "redis-fs-chatbot"
  tier           = "STANDARD_HA"
  memory_size_gb = 5

  region                  = var.region
  authorized_network      = google_compute_network.vpc.id
  connect_mode           = "PRIVATE_SERVICE_ACCESS"

  redis_version      = "REDIS_6_X"
  display_name       = "Forest Service Chatbot Cache"
  reserved_ip_range = "10.100.0.0/28"

  maintenance_policy {
    weekly_maintenance_window {
      day = "SUNDAY"
      start_time {
        hours   = 2
        minutes = 0
      }
    }
  }
}
