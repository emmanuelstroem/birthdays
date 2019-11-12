//  Global IP Address
resource "google_compute_global_address" "birthdays-static-ip" {
  name = "birthdays-ingress-ip"
}

// CloudSQL



// Buckets
resource "google_storage_bucket" "yamls-bucket" {
  name     = "${ var.project_id }-yamls"
  location = "EU"

  versioning { // enable versioning of objects in the bucket
    enabled = true
  } 
}

// CloudBuild Triggers
resource "google_cloudbuild_trigger" "production-master-branch-trigger" {
  trigger_template {
    project_id = "${var.project_id}"
    branch_name = "master"
    repo_name   = "${var.gcp_repository}"
  }

  filename = ".cloudbuild/production.yaml"
}
resource "google_cloudbuild_trigger" "staging-docker-branch-trigger" {
  trigger_template {
    project_id = "${var.project_id}"
    branch_name = "feature-*"
    repo_name   = "${var.gcp_repository}"
  }

  filename = ".cloudbuild/staging.yaml"
}