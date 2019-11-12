// GOOGLE
provider "google" {
  credentials =  "${file("revolut-birthdays-terraform.json")}"
  project     = "${ var.project_id }"
  region      = "${ var.region }"
}

// GOOGLE-BETA
provider "google-beta" {
  credentials =  "${file("revolut-birthdays-terraform.json")}"
  project     = "${ var.project_id }"
  region      = "${ var.region }"
}