#-----------------
# CONSTANT VALUES
#-----------------
locals {
  constants = {

    // DOMAIN INFORMATION
    automation_project_id      = "<PROJECT_ID>" # Project ID that hosts Cloud Build
    billing_account_id         = "000000-000000-000000"             
    cloudbuild_service_account = "<PROJECT_NUMBER>@cloudbuild.gserviceaccount.com" # Cloud Build
    org_id                     = "<ORD_ID>"
    sde_folder_id              = "<FOLDER_ID>"
    terraform_state_bucket     = "<TERRAFORM_STATE_BUCKET>"

    // USERS & GROUPS TO ASSIGN TO THE FOUNDATION PROJECTS
    // format: `user:user1@client.edu`, `group:admins@client.edu`, or `serviceAccount:my-app@appspot.gserviceaccount.com`
    ingress-project-admins = ["group:gcp_security_admins@example.com.com"]
    image-project-admins   = ["group:gcp_security_admins@example.com.com"]
    data-lake-admins       = ["group:gcp_security_admins@example.com.com"]
    data-lake-viewers      = ["group:gcp_security_admins@example.com.com"]
    data-ops-admins        = ["group:gcp_security_admins@example.com.com"]

    // Default Location
    default_region = "us-central1"

    // BRANCH IN VSC
    // Long running Branches. These need to match the branch names in Version Control Software.
    environment = {
      # <branch_name> = <environment_value>
      # Example: main = "prod"
      main = "prod"
    }
  }
}