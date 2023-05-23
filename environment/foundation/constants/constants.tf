#-----------------
# CONSTANT VALUES
#-----------------
locals {
  constants = {

    // DOMAIN INFORMATION
    automation_project_id      = "aaron-cb-sde" # Project ID that hosts Cloud Build
    billing_account_id         = "01EF01-627C10-7CD2DF"             
    cloudbuild_service_account = "213453898789@cloudbuild.gserviceaccount.com" # Cloud Build
    org_id                     = "575228741867"
    sde_folder_id              = "170589415885"
    terraform_state_bucket     = "terraform-state-32f5040503749c0d"

    // USERS & GROUPS TO ASSIGN TO THE FOUNDATION PROJECTS
    // format: `user:user1@client.edu`, `group:admins@client.edu`, or `serviceAccount:my-app@appspot.gserviceaccount.com`
    ingress-project-admins = ["group:sde-centralit@prorelativity.com"]
    image-project-admins   = ["group:sde-centralit@prorelativity.com"]
    data-lake-admins       = ["group:gcp_security_admins@prorelativity.com"]
    data-lake-viewers      = ["group:gcp_security_admins@prorelativity.com"]
    data-ops-admins        = ["group:gcp_security_admins@prorelativity.com"]

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
      # Example: main = "prod"
      main = "qa"
    }
  }
}