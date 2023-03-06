resource "google_cloudbuild_trigger" "bootstrap_trigger" {
  project = var.project_id
  name    = "bootstrap-trigger"

  disabled = true
  filename = "cloudbuild/foundation/cloudbuild-sde-apply.yaml"

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = false
      branch       = var.branch_name
    }
  }

  substitutions = {
    _BUCKET = google_storage_bucket.tfstate.name
    _PREFIX = "foundation"
    _TAG    = "1.3.6"
  }
}
# -------------------------------------------------------
# VARIABLES
# -------------------------------------------------------

variable "github_owner" {
  description = "GitHub Organization Name"
  type        = string
  default     = "Burwood"
}

variable "github_repo_name" {
  description = "Name of GitHub Repo"
  type        = string
  default     = "terraform-google-sde"
}

variable "branch_name" {
  description = "Regex matching branches to build. Exactly one a of branch name, tag, or commit SHA must be provided. The syntax of the regular expressions accepted is the syntax accepted by RE2 and described at https://github.com/google/re2/wiki/Syntax"
  type        = string
  default     = "^base-1$"
}