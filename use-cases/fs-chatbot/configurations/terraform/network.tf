# network.tf

# VPC Configuration
resource "google_compute_network" "vpc" {
  name                    = "vpc-fs-chatbot"
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Subnet Configuration
resource "google_compute_subnetwork" "private" {
  name          = "subnet-private-fs-chatbot"
  ip_cidr_range = "10.0.0.0/20"
  region        = var.region
  network       = google_compute_network.vpc.id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}

# Cloud NAT Configuration
resource "google_compute_router" "router" {
  name    = "router-fs-chatbot"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-fs-chatbot"
  router                            = google_compute_router.router.name
  region                            = var.region
  nat_ip_allocate_option            = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
