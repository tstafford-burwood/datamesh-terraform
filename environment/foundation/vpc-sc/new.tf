locals {
  perimeter_members_data_ingestion = distinct(concat([
    "serviceAccount:${local.cloudbuild_service_account}",
    "serviceAccount:${local.composer_sa}",
    "serviceAccount:service-${local.data_ops}@compute-system.iam.gserviceaccount.com",
    "serviceAccount:${local.data_ops}@cloudbuild.gserviceaccount.com",
    "serviceAccount:service-${local.data_ops}@gcf-admin-robot.iam.gserviceaccount.com",
    "serviceAccount:${local.image_project_sa}",
  ], var.perimeter_additional_members))

  base_restricted_services = [
    "bigquery.googleapis.com",
    "cloudasset.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "datacatalog.googleapis.com",
    "dataflow.googleapis.com",
    "dlp.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "pubsub.googleapis.com",
    "secretmanager.googleapis.com",
    "sts.googleapis.com",
    "iam.googleapis.com",
    "storage.googleapis.com"
  ]

  restricted_services = distinct(concat(local.base_restricted_services))
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "secure_data" {
  source = "../../../modules/vpc-sc"

  access_context_manager_policy_id = "428294780283"
  common_name                      = "data_enclave"
  common_suffix                    = random_id.suffix.hex
  resources = [
    local.data_ingress,
    local.data_ops,
    local.data_lake,
  ]

  perimeter_members   = local.perimeter_members_data_ingestion # users or service accounts
  restricted_services = local.restricted_services

  ingress_policies = [
    {
      "from" = {
        "sources" = {
          # allow any of the service accounts to to hit the listed APIs
          #access_levels = [module.access_level_service-accounts.name]
          access_levels = ["*"]
        },
        "identity_type" = "ANY_SERVICE_ACCOUNT"
      }
      "to" = {
        "resources" = ["*"]
        "operations" = {
          "container.googleapis.com" = {
            "methods" = ["*"]
          },
          "monitoring.googleapis.com" = {
            "methods" = ["*"]
          },
          "cloudfunctions.googleapis.com" = {
            "methods" = ["*"]
          },
          "artifactregistry.googleapis.com" = {
            "methods" = ["*"]
          },
          "compute.googleapis.com" = {
            "methods" = ["*"]
          },
          "storage.googleapis.com" = {
            "methods" = ["*"]
          }
        }
      }
    },
  ]

  egress_policies = [{
    "from" = {
      "identity_type" = "ANY_SERVICE_ACCOUNT"
      "identities"    = []
    },
    "to" = {
      "resources" = ["*"]
      "operations" = {
        "container.googleapis.com" = {
          "methods" = ["*"]
        },
        "monitoring.googleapis.com" = {
          "methods" = ["*"]
        },
        "cloudfunctions.googleapis.com" = {
          "methods" = ["*"]
        },
        "artifactregistry.googleapis.com" = {
          "methods" = ["*"]
        },
        "compute.googleapis.com" = {
          "methods" = ["*"]
        }
      }
    }
  }, ]
}