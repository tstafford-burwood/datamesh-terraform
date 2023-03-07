#-----------------
# CONSTANT VALUES
#-----------------
locals {
  constants = {

    // DOMAIN INFORMATION
    org_id                     = "575228741867"         # gcloud organizations list                             
    billing_account_id         = "01EF01-627C10-7CD2DF" # gcloud alpha billing accounts list
    sde_folder_id              = "319001085975"
    automation_project_id      = "github-actions-demos"
    cloudbuild_service_account = "62218100388@cloudbuild.gserviceaccount.com"
    terraform_state_bucket     = "terraform-state-36e9e98f98120dcd"

    // USERS & GROUPS TO ASSIGN TO THE FOUNDATION PROJECTS
    // format: `user:user1@client.edu`, `group:admins@client.edu`, or `serviceAccount:my-app@appspot.gserviceaccount.com`
    ingress-project-admins = ["group:sde-centralit@prorelativity.com"]
    image-project-admins   = ["group:sde-centralit@prorelativity.com"]
    data-lake-admins       = ["group:sde-centralit@prorelativity.com"]
    data-lake-viewers      = ["group:sde-centralit@prorelativity.com"]
    data-ops-admins        = ["group:sde-centralit@prorelativity.com"]

    // ONLY USERS OR SERVICE ACCOUNTS TO ASSIGN TO VPC PERIMETER
    # `vpc_sc_admins` are added to an access context level which grants them full access to all restricted services for all foundation projects
    # `vpc_sc_stewards` are added to an access context level. This access level `sde_{env}_stewards`, has an allow rule in the VPC SC that grants this access level to use the storage api only in the data ingress project.
    #   this is to allow stewards to upload files to a bucket in the data ingress project.

    vpc_sc_admins = []

    // Default Location
    default_region = "us-central1"

    // BRANCH IN VSC
    // Long running Branches. These need to match the branch names in Version Control Software.
    environment = {
      # <branch_name> = <environment_value>
      base-1 = "qa"
    }
  }
}