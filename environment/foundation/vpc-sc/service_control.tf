# Default VPC Service Controls perimeter and access list.
module "data_ingestion_vpc_sc" {
  source = "GoogleCloudPlatform/secured-data-warehouse/google//modules//dwh-vpc-sc"


  org_id                           = "575228741867"
  project_id                       = "qa-sde-data-ops-76c9"
  access_context_manager_policy_id = "428294780283"
  common_name                      = "data_enclave"
  common_suffix                    = random_id.suffix.hex
  resources = {
    data_ingestion = local.data_ingress
    data_ops       = local.data_ops
    data_lake      = local.data_lake
  }                                                            # List of GCP projects
  perimeter_members   = local.perimeter_members_data_ingestion # users or service accounts
  restricted_services = local.restricted_services              # list of restricted services

  egress_policies = var.egress_policies

  # depends_on needed to prevent intermittent errors
  # when the VPC-SC is created but perimeter member
  # not yet propagated.
}

resource "random_id" "suffix" {
  byte_length = 4
}

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

  restricted_services = distinct(concat(local.base_restricted_services, var.additional_restricted_services))

  egress_rules = [
    {
      "from" = {
        "identity_type" = ""
        "identities" = distinct(concat(
          var.data_ingestion_dataflow_deployer_identities,
          ["serviceAccount:${local.cloudbuild_service_account}"]
        ))
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
          },
          "storage.googleapis.com" = {
            "methods" = ["*"]
          }
        }
      }
    },
  ]
}