data "google_compute_network" "mainnetwork_data" {
  name = "${ var.region }"
}

output "network_selflink" {
  value = "${google_compute_network.mainnetwork.self_link}"
}
