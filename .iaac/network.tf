// VPC
resource "google_compute_network" "mainnetwork" {
  name = "mainvpc"
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
  project = "${ var.project_id }"
}

// SUBNETWORKS
resource "google_compute_subnetwork" "europ-west1-subnetwork" {
  name          = "${ var.europe-west1-subnetwork["name"] }"
  ip_cidr_range = "${ var.europe-west1-subnetwork["ip_cidr_range"] }"
  region        = "${ var.europe-west1-subnetwork["region"] }"
  network       = "${google_compute_network.mainnetwork.self_link}"
}

// FIREWALL
resource "google_compute_firewall" "default" {
  name    = "birthday-firewall"
  network = "${google_compute_network.mainnetwork.name}"

  allow {
    protocol = "icmp"
  }

  allow { // allow 80,8080, add 443 for ssl
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

// CLOUD NAT
// cloud-router
resource "google_compute_router" "europe-west1-router"{
    name    = "europe-west1-router"
    region  = "${ var.europe-west1-subnetwork["region"] }"
    network = "${google_compute_network.mainnetwork.self_link}"

    bgp {
        asn = 64514
    }
}

// clout-nat
resource "google_compute_router_nat" "nat" {
    name                               = "europe-west1-nat"
    router                             = google_compute_router.europe-west1-router.name
    region                             = "${ var.europe-west1-subnetwork["region"] }"
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

    log_config {
      enable = true
      filter = "ERRORS_ONLY"
    }
}

// Managed DNS
// DNS Zone
resource "google_dns_managed_zone" "production-zone" {
  name = "production-zone"
  dns_name = "birthday.production.local"
  description = "private DNS zone"
  labels = {
    app = "birthday"
    env = "production"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url =  "${google_compute_network.mainnetwork.self_link}"
    }
  }
}

// DNS Records
resource "google_dns_record_set" "a" {
  name = "birthdays.production.cloudsql.local"
  managed_zone = "${google_dns_managed_zone.production-zone.name}"
  type = "A"
  ttl  = 300

  rrdatas = ["8.8.8.8"]
}
