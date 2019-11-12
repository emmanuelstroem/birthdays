// Project
variable "project_id" {
  type = "string"
  default = "revolut-birthdays"
}

variable "region" {
  type = "string"
  default = "europe-west1"
}

// Network
variable "europe-west1-subnetwork" {
  type = "map"
  default = {
    name = "europe-west1-subnetwork"
    region = "europe-west1"
    ip_cidr_range = "10.132.0.0/20"
    pods_range = "10.28.0.0/14"
    services_range = "172.18.32.0/19"
  }
}

// GIT
variable "gcp_repository" {
  type = "string"
  default = "github_emmanuelstroem_birthdays"
}

// CloudSQL
variable "database_version" {
  type = "string"
  default = "POSTGRES_9_6"
}