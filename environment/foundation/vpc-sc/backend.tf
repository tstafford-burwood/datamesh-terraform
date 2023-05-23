// BACKEND AND REQUIRED PROVIDERS BLOCK

terraform {
  #backend "gcs" {}
  required_version = ">= 1.1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.20.0" # tftest
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.20.0" # tftest
    }
  }
}