module "gcs_bucket_shared" {
  # Create a bucket for shared information for all researchers to use

  source           = "terraform-google-modules/cloud-storage/google"
  version          = "~> 3.0"
  project_id       = module.workspace_project.project_id
  location         = local.region
  randomize_suffix = true
  prefix           = "sde-${local.environment[terraform.workspace]}"
  names            = ["shared"]

  set_creator_roles = true
  set_viewer_roles  = true

  # create folder(s) in the shared gcs bucket
  folders = {
    "shared" = ["EGRESS", "USERS"]
  }

  force_destroy = {
    "sde-${local.environment[terraform.workspace]}" = var.force_destroy
  }
}