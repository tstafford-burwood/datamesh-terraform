#-----------------
# CONSTANT VALUES
#-----------------
locals {
  constants = {

    // DOMAIN INFORMATION
    automation_project_id      = "aaron-cb-sde" # Project ID that hosts Cloud Build
    billing_account_id         = "01EF01-627C10-7CD2DF"             
    cloudbuild_service_account = "213453898789@cloudbuild.gserviceaccount.com" # Cloud Build
    org_id                     = "575228741867" # gcloud organizations list
    sde_folder_id              = "720656688626"
    terraform_state_bucket     = "terraform-state-edafe2a65b489823"

    // USERS & GROUPS TO ASSIGN TO THE FOUNDATION PROJECTS
    // format: `user:user1@client.edu`, `group:admins@client.edu`, or `serviceAccount:my-app@appspot.gserviceaccount.com`
    ingress-project-admins = ["group:gcp_security_admins@prorelativity.com"]
    image-project-admins   = ["group:gcp_security_admins@prorelativity.com"]
    data-lake-admins       = ["group:gcp_security_admins@prorelativity.com"]
    data-lake-viewers      = ["group:gcp_security_admins@prorelativity.com"]
    data-ops-admins        = ["group:gcp_security_admins@prorelativity.com"]

    // Default Location
    default_region = "us-central1"

    // BRANCH IN VSC
    // Long running Branches. These need to match the branch names in Version Control Software.
    environment = {
      # <branch_name> = <environment_value>
      # Example: main = "prod"
      ft-centralized-logging = "prod"
    }
  }
}