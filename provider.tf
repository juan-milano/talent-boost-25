terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0" # Specify a version constraint
    }
  }
}


locals {
  tf_sa = var.token_service_account
}

# Configure the Google Cloud provider
provider "google" {
  impersonate_service_account = local.tf_sa
    project     = var.project_id
  region      = var.region_name

}
provider "google-beta" {
  impersonate_service_account = local.tf_sa
    project     = var.project_id
  region      = var.region_name
}