org_id                     = "<ORG_ID>"                                        # run `gcloud organization list` to get ORG_ID
cloudbuild_service_account = "<PROJECT_NUMBER>@cloudbuild.gserviceaccount.com" # This will be the project number that hosts Cloud Build
billing_display_name       = "<BILLING_ACCOUNT_NAME>"                          # Enter Billing Account Name, not the ID
project_id                 = "github-actions-demos"                            # The Google Project ID to host the bucket.                               

git_repo_url = "https://github.com/Burwood/terraform-gcp-sde"
git_path     = "cloudbuild/foundation/cloudbuild-sde-apply.yaml"
