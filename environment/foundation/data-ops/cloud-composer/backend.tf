// BACKEND BLOCK

terraform {
  backend "gcs" {}
  required_version = ">= 0.13.0"
  required_providers {
    google      = "~> 3.65.0"
    google-beta = "~> 3.65.0"
  }
}
