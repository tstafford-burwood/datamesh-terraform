org_id                     = "575228741867"                                # run `gcloud organization list` to get ORG_ID
cloudbuild_service_account = "213453898789@cloudbuild.gserviceaccount.com" # This will be the project number that hosts Cloud Build
billing_display_name       = "prorelativity"                               # Enter Billing Account Name, not the ID
project_id                 = "aaron-cb-sde"                                # The Google Project ID to host the bucket.                               
parent_folder              = "684808102738"                                # Optional, a pre-existing parent folder to nest `folder_name` underneath

git_repo_url = "https://github.com/Burwood/terraform-gcp-sde"
git_path     = "cloudbuild/foundation/cloudbuild-sde-apply.yaml"
git_ref      = "refs/heads/main" # What ref should be built by the Cloud Build trigger.