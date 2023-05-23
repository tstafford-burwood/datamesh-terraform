org_id                     = "195074099351"                                        # run `gcloud organization list` to get ORG_ID
cloudbuild_service_account = "362800255770@cloudbuild.gserviceaccount.com" # This will be the project number that hosts Cloud Build
billing_display_name       = "prorelativity"                          # Enter Billing Account Name, not the ID
project_id                 = "sde-bootstrap-386401"                            # The Google Project ID to host the bucket.                               
folder_name                = "tuned-cold-sde"                                   # To nest folder under the org level -or-
parent_folder              = "125267275488"                 # Optional, a pre-existing parent folder to nest `folder_name` underneath

git_repo_url = "https://github.com/Burwood/terraform-gcp-sde"
git_path     = "cloudbuild/foundation/cloudbuild-sde-apply.yaml"
git_ref      = "tunedcold-sde" # What ref should be built by the Cloud Build trigger.