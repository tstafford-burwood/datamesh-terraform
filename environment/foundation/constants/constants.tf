#-----------------
# CONSTANT VALUES
#-----------------
locals {
  constants = {

    // DOMAIN INFORMATION
    org_id                     = "956334456591" # gcloud organizations list                             
    billing_account_id         = "019D3A-6DC5E4-54D0C6"
    sde_folder_id              = "396928138340"
    automation_project_id      = "prod-pittit-automation-21012"
    cloudbuild_service_account = "68129454576@cloudbuild.gserviceaccount.com"
    terraform_state_bucket     = "terraform-state-sde-prod-7dkc"

    // USERS & GROUPS TO ASSIGN TO THE FOUNDATION PROJECTS
    // format: `user:user1@pitt.edu`, `group:admins@pitt.edu`, or `serviceAccount:my-app@appspot.gserviceaccount.com`
    ingress-project-admins = ["user:astrong@burwood.com"]
    image-project-admins   = ["user:tap145@pitt.edu", "user:astrong@burwood.com"]
    data-lake-admins       = ["user:tap145@pitt.edu", "user:astrong@burwood.com"]
    data-lake-viewers      = ["user:tap145@pitt.edu", "user:astrong@burwood.com"]
    data-ops-admins        = ["user:tap145@pitt.edu", "user:astrong@burwood.com"]
    data-ops-stewards      = []
    data-ops-analysts      = []

    // ONLY USERS OR SERVICE ACCOUNTS TO ASSIGN TO VPC PERIMETER
    # `vpc_sc_admins` are added to an access context level which grants them full access to all restricted services for all foundation projects
    # `vpc_sc_stewards` are added to an access context level. This access level `sde_{env}_stewards`, has an allow rule in the VPC SC that grants this access level to use the storage api only in the data ingress project.
    #   this is to allow stewards to upload files to a bucket in the data ingress project.

    vpc_sc_admins   = []
    vpc_sc_stewards = [] # Only `users` or `serviceAccounts` allowed.

    // Default Location
    default_region = "us-central1"

    // BRANCH IN VSC
    // Long running Branches. These need to match the branch names in Version Control Software.
    environment = {
      # <branch_name> = <environment_value>
      main = "prod"
    }
  }
}