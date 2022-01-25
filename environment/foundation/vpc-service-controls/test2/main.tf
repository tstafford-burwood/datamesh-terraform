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
  version        =  "3.1.0"
  #policy         = module.org_policy.policy_id
  policy         = "548853993361"
  perimeter_name = "sde_scp_2"
  description    = "Secure Data VPC Service Perimeter"
  resources      = ["207846422464"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  ingress_policies = [{
      "from" = {
        "sources" = {
          resources = [
            "projects/810291290728",
            "projects/947222372583"
          ],
          access_levels = [
              "access_level_sde_2"
          ]
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
        "identities"    = [""]
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