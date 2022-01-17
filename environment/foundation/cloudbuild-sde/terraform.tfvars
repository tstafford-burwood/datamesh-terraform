# ---------------------------------------------------------
# STEP 1:
# CHANGE AFTER THE AUTOMATION PROJECT IS UP AND HAS A BUCKET AND PREFIX
# ---------------------------------------------------------


# ---------------------------------------------------------
# STEP 2:
# CHANGE AFTER PACKER PROJECT IS UP
# ---------------------------------------------------------

packer_project_id = "aaron3-packer-ba08" // CHANGE AFTER PACKER PROJECT IS UP

# ---------------------------------------------------------
# STEP 3
# CHANGE AFTER STAGING AND CLOUD COMPOSER ARE UP
# ---------------------------------------------------------

#composer_dag_bucket = "us-central1-composer-all-pr-77f45ed9-bucket" // CHANGE AFTER CLOUD COMPOSER IS UP

# ---------------------------------------------------------
# CHANGE BASED ON WHAT CODE REPO IS BEING USED.
# These pipelines and code below is for BitBucket
# ---------------------------------------------------------

#plan_trigger_repo_name  = "bitbucket_rkoliyatt-burwood_cornell-onboarding1" // CHANGE BEFORE FIRST DEPLOYMENT
plan_branch_name = "^main$" // CHANGE BEFORE FIRST DEPLOYMENT
#apply_trigger_repo_name = "bitbucket_rkoliyatt-burwood_cornell-onboarding1"
apply_branch_name = "^main$"

github_owner     = "Burwood"
github_repo_name = "terraform-gcp-sde"


