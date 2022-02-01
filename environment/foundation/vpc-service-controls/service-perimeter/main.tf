#------------------
# IMPORT CONSTANTS
#------------------

#provider "google" {
# project = "automation-dan-sde"
#}

module "constants" {
  source = "../../constants"
}

#------------------------------------------------------------------------
# RETRIEVE ACCESS LEVEL TF STATE
#------------------------------------------------------------------------

data "terraform_remote_state" "access_level_cloudbuild_dev" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev, "access-level-cloudbuild")
  }
}

data "terraform_remote_state" "access_level_cloudbuild_prod" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod, "access-level-cloudbuild")
  }
}

// SET LOCAL VALUES

locals {
  parent_access_policy_id    = module.constants.value.parent_access_policy_id
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account

   # Check if the access level cloudbuild has been deployed, if not default to empty string
  access_level_cloudbuild_id_dev  = try(data.terraform_remote_state.access_level_cloudbuild_dev.outputs.name_id, "")
  access_level_cloudbuild_id_prod  = try(data.terraform_remote_state.access_level_cloudbuild_prod.outputs.name_id, "")

}

#resource "google_access_context_manager_service_perimeter_resource" "service-perimeter-resource" {
#  perimeter_name = google_access_context_manager_service_perimeter.service-perimeter-resource.name
#  resource       = "projects/207846422464"
#}


resource "google_access_context_manager_service_perimeter" "service-perimeter-resource" {
  parent = format("accessPolicies/%s", local.parent_access_policy_id)
  name   = format("accessPolicies/%s/servicePerimeters/sde_scp_%s", local.parent_access_policy_id, var.environment)
  title  = "sde_scp_3"
  perimeter_type = "PERIMETER_TYPE_REGULAR"
  status {
    restricted_services = var.restricted_services
    resources = var.scp_perimeter_projects
    #access_levels = ["accessPolicies/548853993361/accessLevels/cloudbuild"]
    access_levels = [local.access_level_cloudbuild_id_dev]

    vpc_accessible_services {
      enable_restriction = true
      allowed_services   = var.vpc_accessible_services
    }

    #cloudbuild access
    ingress_policies {

      ingress_from {
        identity_type = "ANY_SERVICE_ACCOUNT"
        identities    = [""]
        sources {
          #access_level = "accessPolicies/548853993361/accessLevels/cloudbuild"
          access_level = local.access_level_cloudbuild_id_dev
        }
      }
      ingress_to {
        resources = ["*"]
      }
    }

    #data ingress
    ingress_policies {

      ingress_from {
        identity_type = "ANY_SERVICE_ACCOUNT"
        identities    = [""]
      }
      ingress_to {
        resources = var.data_ingress_project_numbers
        operations {
          service_name = "storage.googleapis.com"

          method_selectors {
            method = "google.storage.objects.create"
          }
        }
      }
    }

    # data egress
    egress_policies {
      egress_from {
        identity_type = ""
        identities    = ["serviceAccount:staging-scp-temp@automation-dan-sde.iam.gserviceaccount.com"]
      }
      egress_to {
        resources = var.data_ops_egress_project_numbers
        operations {
          service_name = "bigquery.googleapis.com"

          method_selectors {
            method = "DatasetService.GetDataset"
          }
          method_selectors {
            method = "DatasetService.InsertDataset"
          }
          method_selectors {
            method = "DatasetService.ListDatasets"
          }
          method_selectors {
            method = "DatasetService.ListDatasets"
          }
          method_selectors {
            method = "DatasetService.PatchDataset"
          }
          method_selectors {
            method = "DatasetService.UpdateDataset"
          }
          method_selectors {
            method = "JobService.CancelJob"
          }
          method_selectors {
            method = "JobService.DeleteJob"
          }
          method_selectors {
            method = "JobService.GetJob"
          }
          method_selectors {
            method = "JobService.GetQueryResults"
          }
          method_selectors {
            method = "JobService.InsertJob"
          }
          method_selectors {
            method = "JobService.ListJobs"
          }
          method_selectors {
            method = "JobService.Query"
          }
          method_selectors {
            method = "TableService.DeleteTable"
          }
          method_selectors {
            method = "TableService.GetTable"
          }
          method_selectors {
            method = "TableService.InsertTable"
          }
          method_selectors {
            method = "TableService.ListTables"
          }
          method_selectors {
            method = "TableService.PatchTable"
          }
          method_selectors {
            method = "TableService.UpdateTable"
          }
        }
        operations {
          service_name = "storage.googleapis.com"

          method_selectors {
            method = "google.storage.buckets.create"
          }

          method_selectors {
            method = "google.storage.buckets.delete"
          }

          method_selectors {
            method = "google.storage.buckets.get"
          }

          method_selectors {
            method = "google.storage.buckets.list"
          }

          method_selectors {
            method = "google.storage.buckets.update"
          }

          method_selectors {
            method = "google.storage.objects.create"
          }

          method_selectors {
            method = "google.storage.objects.delete"
          }

          method_selectors {
            method = "google.storage.objects.get"
          }

          method_selectors {
            method = "google.storage.objects.list"
          }

          method_selectors {
            method = "google.storage.objects.update"
          }
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

