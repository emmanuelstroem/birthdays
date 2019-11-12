resource "google_compute_global_address" "production-cloudsql-ip" {
    provider = "google-beta"
    name          = "production-cloudsql-ip"
    purpose       = "VPC_PEERING"
    address_type = "INTERNAL"
    prefix_length = 16
    network       = "${google_compute_network.mainnetwork.self_link}"
}

resource "google_service_networking_connection" "staging_pgsql_private_vpc_connection" {
    provider      = "google-beta"
    network       = "${google_compute_network.staging_database_network.self_link}"
    service       = "servicenetworking.googleapis.com"
    reserved_peering_ranges = ["${google_compute_global_address.staging_pgsql_private_ip_address.name}"]
}

resource "google_sql_database_instance" "birthdays_production_db_instance" {
    project = "${ var.project_id }"
    depends_on = ["google_service_networking_connection.staging_pgsql_private_vpc_connection"]
    name = "${ var.database_name }"
    region = "${ var.databse_region }"
    database_version = "${ var.database_version }"

    settings {
        tier = "${ var.database_tier }"
        # disk_size = "10"
        # disk_type = "PD_SSD"

        ip_configuration {
            ipv4_enabled = "false"
            private_network = "${google_compute_network.staging_database_network.self_link}"
        }

        backup_configuration {
            enabled = true
            start_time = "23:00"
        }
    }
}