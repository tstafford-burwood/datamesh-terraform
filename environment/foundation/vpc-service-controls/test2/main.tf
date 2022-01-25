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
        resources = var.bastion_project_numbers
      },
      "identity_type" = ""
      "identities"    = [""]
    }
    "to" = {
      "operations" = {
        "bigquery.googleapis.com" = {
          "methods" = [
            "BigQueryStorage.ReadRows",
            "TableService.ListTables"
          ],
          "permissions" = [
            "bigquery.jobs.get"
          ]
        }
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
      "sources" = {
         resources = var.data_ops_egress_project_numbers
      }
    },
    "to" = {
      "resources" = ["*"]
      "operations" = {
        "bigquery.googleapis.com" = {
          "methods" = [
            "BigQueryStorage.ReadRows",
            "TableService.ListTables"
          ],
          "permissions" = [
            "bigquery.jobs.get"
          ]
        }
        "storage.googleapis.com" = {
          "methods" = [
            "google.storage.objects.create"
          ]
        }
      }
    }
    },
  ]
}