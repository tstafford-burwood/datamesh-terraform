#------------------
# IMPORT CONSTANTS
#------------------


module "constants" {
  source = "../../constants"
}

// SET LOCAL VALUES

locals {
  parent_access_policy_id    = module.constants.value.parent_access_policy_id
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  #cloudbuild_access_level_name = module.constants.value.cloudbuild_access_level_name
}

module "regular_service_perimeter_1" {
  source         = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version        = "3.1.0"
  policy         = local.parent_access_policy_id
  perimeter_name = "sde_scp_2"
  description    = "Secure Data VPC Service Perimeter"
  resources      = var.resources

  restricted_services = var.restricted_services

  ingress_policies = [{
    "from" = {
      "sources" = {
      },
      "identity_type" = "ANY_IDENTITY"
      "identities"    = [""]
    }
    "to" = {
      "operations" = {
        "storage.googleapis.com" = {
          "methods" = [
            "google.storage.objects.create"
          ]
        }
      }
    }
    },
  ]
  egress_policies = [{
    "from" = {
      "identity_type" = ""
      "identities"    = ["serviceAccount:staging-scp-temp@automation-dan-sde.iam.gserviceaccount.com"]
    },
    "to" = {
      "resources" = var.data_ops_egress_project_numbers
      "operations" = {
        "bigquery.googleapis.com" = {
          "methods" = [
            "DatasetService.GetDataset",
            "DatasetService.InsertDataset",
            "DatasetService.ListDatasets",
            "DatasetService.PatchDataset",
            "DatasetService.UpdateDataset",
            "JobService.CancelJob",
            "JobService.DeleteJob",
            "JobService.GetJob",
            "JobService.GetQueryResults",
            "JobService.InsertJob",
            "JobService.ListJobs",
            "JobService.Query",
            "TableService.DeleteTable",
            "TableService.GetTable",
            "TableService.InsertTable",
            "TableService.ListTables",
            "TableService.PatchTable",
            "TableService.UpdateTable"
          ]
        }
        "storage.googleapis.com" = {
          "methods" = [
            "google.storage.buckets.create",
            "google.storage.buckets.delete",
            "google.storage.buckets.get",
            "google.storage.buckets.list",
            "google.storage.buckets.update",
            "google.storage.objects.create",
            "google.storage.objects.delete",
            "google.storage.objects.get",
            "google.storage.objects.list",
            "google.storage.objects.update"
          ]
        }
      }
    }
    },
  ]
}