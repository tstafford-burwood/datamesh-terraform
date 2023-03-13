#-----------------
# CONSTANT VALUES
#-----------------
locals {
  constants = {

    // DOMAIN INFORMATION
    org_id                     = var.org_id         # gcloud organizations list                             
    billing_account_id         = var.billing_account_id # gcloud alpha billing accounts list
    sde_folder_id              = var.sde_folder_id
    automation_project_id      = var.automation_project_id
    cloudbuild_service_account = var.cloudbuild_service_account
    terraform_state_bucket     = var.terraform_state_bucket

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
    default_region = var.default_region

    // BRANCH IN VSC
    // Long running Branches. These need to match the branch names in Version Control Software.
    environment = {
      # <branch_name> = <environment_value>
      base-1 = "qa"
    }
  }
}