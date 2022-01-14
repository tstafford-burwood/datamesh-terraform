# ---------------------------------------------------------
# STEP 1:
# CHANGE AFTER THE AUTOMATION PROJECT IS UP AND HAS A BUCKET AND PREFIX
# ---------------------------------------------------------

terraform_state_bucket = "terraform-state-sde-1292" // CHANGE BEFORE FIRST DEPLOYMENT
terraform_state_prefix = "cloudbuild-sde"           // CHANGE BEFORE FIRST DEPLOYMENT

terraform_foundation_state_prefix = "foundation"
terraform_deployments_state_prefix = "deployments"

# ---------------------------------------------------------
# STEP 2:
# CHANGE AFTER PACKER PROJECT IS UP
# ---------------------------------------------------------

srde_packer_project_id = "aaron3-packer-ba08" // CHANGE AFTER PACKER PROJECT IS UP

# ---------------------------------------------------------
# STEP 3
# CHANGE AFTER STAGING AND CLOUD COMPOSER ARE UP
# ---------------------------------------------------------

srde_composer_dag_bucket = "us-central1-composer-all-pr-77f45ed9-bucket" // CHANGE AFTER CLOUD COMPOSER IS UP

# ---------------------------------------------------------
# CHANGE BASED ON WHAT CODE REPO IS BEING USED.
# These pipelines and code below is for BitBucket
# ---------------------------------------------------------

#srde_plan_trigger_repo_name  = "bitbucket_rkoliyatt-burwood_cornell-onboarding1" // CHANGE BEFORE FIRST DEPLOYMENT
srde_plan_branch_name        = "^main$"                              // CHANGE BEFORE FIRST DEPLOYMENT
#srde_apply_trigger_repo_name = "bitbucket_rkoliyatt-burwood_cornell-onboarding1"
srde_apply_branch_name       = "^main$"

github_owner = "Burwood"
github_repo_name = "terraform-gcp-sde"


