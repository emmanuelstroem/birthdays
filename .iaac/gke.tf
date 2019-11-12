// GKE
// Cluster
resource "google_container_cluster" "birthdays-gke-cluster" {
  name     = "birthdays-europe-west1-cluster"
  location = "${ var.region }"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network = "${google_compute_network.mainnetwork.self_link}"
  subnetwork = "${google_compute_subnetwork.europ-west1-subnetwork.self_link}"

//   network = "projects/${ var.database_project_id }/global/networks/${ var.shared_vpc_name }"
//   subnetwork = "projects/${ var.database_project_id }/regions/${ var.region }/subnetworks/${ var.shared_vpc_name }"

}

// Node Pool
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "standard-1-node-pool"
  location   = "${ var.region }"
  cluster    = "${google_container_cluster.birthdays-gke-cluster.name}"
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/sqlservice.admin",
    ]

    labels = {
      env = "production"
    }
  }

    autoscaling {
        min_node_count = 1
        max_node_count = 3
    }

    management {
        auto_repair  = true
        auto_upgrade = true
    }
}