#------------------
# IMPORT CONSTANTS
#------------------


provider "google" {
  project = "automation-dan-sde"
}

module "constants" {
  source = "../../constants"
}

// SET LOCAL VALUES

locals {
  parent_access_policy_id    = module.constants.value.parent_access_policy_id
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  #cloudbuild_access_level_name = module.constants.value.cloudbuild_access_level_name
}


resource "google_access_context_manager_service_perimeter" "service-perimeter-resource" {
  parent = "accessPolicies/548853993361"
  name   = "accessPolicies/548853993361/servicePerimeters/restrict_all"
  title  = "sde_scp"
  status {
    restricted_services = ["storage.googleapis.com"]

    vpc_accessible_services {
      enable_restriction = true
      allowed_services   = ["storage.googleapis.com"]
    }

    ingress_policies {
      ingress_from {
        identity_type = ""
        identities    = [""]
        sources {
          resource = "projects/1111"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [status[0].resources]
  }


}

#resource "google_access_context_manager_access_policy" "access-policy" {
#  parent = "organizations/645343216837"
#  title  = "access-policy-sde"
#}



resource "google_access_context_manager_service_perimeter_resource" "service-perimeter-resource" {
  perimeter_name = google_access_context_manager_service_perimeter.service-perimeter-resource.name
  resource       = "projects/207846422464"
}