// BACKEND AND REQUIRED PROVIDERS BLOCK

terraform {
  backend "gcs" {}
  required_providers {
    google      = "~> 3.65.0"
    google-beta = "~> 3.65.0"
  }
}