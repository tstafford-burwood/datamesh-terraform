#------------------------------------------------------------------------
# VPC Perimeters
#------------------------------------------------------------------------

module "foundation_perimeter_0" {
  # Create a vpc perimeter around the core foundational projects
  source         = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version        = "~>4.0"
  policy         = var.parent_access_policy_id
  perimeter_name = "${local.environment[terraform.workspace]}_foundation"

  description = "Perimeter shielding foundation projects - Terraform Managed"
  resources   = [local.data_ops, local.data_lake, local.data_ingress]

  # The service accounts for cloud build, data-ops: notebooks-sa and composer-sa MUST be added to the access_levels
  access_levels = local.fnd_pe_0_acclvl

  # do not add logging, monitoring, and container to perimeter - this breaks the ability to see the overall health of a cloud composer environment
  restricted_services     = ["bigquery.googleapis.com", "storage.googleapis.com", "aiplatform.googleapis.com"]
  vpc_accessible_services = ["storage.googleapis.com", "pubsub.googleapis.com", "logging.googleapis.com", "notebooks.googleapis.com", "bigquery.googleapis.com", "monitoring.googleapis.com", "container.googleapis.com", "dlp.googleapis.com", "datacatalog.googleapis.com", "containerregistry.googleapis.com", "artifactregistry.googleapis.com", "sqladmin.googleapis.com", "vpcaccess.googleapis.com", "compute.googleapis.com", "integrations.googleapis.com", "cloudfunctions.googleapis.com"]

  ingress_policies = [
    {
      "from" = {
        "sources" = {
          # allow any of the service accounts to to hit the listed APIs
          #access_levels = [module.access_level_service-accounts.name]
          access_levels = []
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
          }
        }
      }
    },
    {
      "from" = {
        "sources" = {
          # allow the stewards to access the storage api in data ingress prj
          #access_levels = [module.access_level_stewards.name]
          access_levels = []
        },
        "identity_type" = "ANY_USER_ACCOUNT"
      }
      "to" = {
        "resources" = ["projects/${local.data_ingress}", "projects/${local.data_ops}", "projects/${local.data_lake}"]
        "operations" = {
          "storage.googleapis.com" = {
            "methods" = ["*"]
          },
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

module "foundation_perimeter_1" {
  source         = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version        = "~>4.0"
  policy         = local.parent_access_policy_id
  perimeter_name = format("%s_foundation_imaging", local.environment[terraform.workspace])
  description    = "Perimeter shielding imaging project - Terraform Managed"
  resources      = [local.image_project]

  access_levels           = local.fnd_pe_1_acclvl
  restricted_services     = ["run.googleapis.com", "bigquery.googleapis.com", "bigtable.googleapis.com", "sqladmin.googleapis.com", "pubsub.googleapis.com", "container.googleapis.com"]
  vpc_accessible_services = ["notebooks.googleapis.com", "compute.googleapis.com", "storage.googleapis.com", "artifactregistry.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
  ingress_policies = [
    {
      "from" = {
        "sources" = {
          # allow any of the service accounts to to hit the listed APIs
          access_levels = [module.access_level_service-accounts.name]
        },
        "identity_type" = "ANY_SERVICE_ACCOUNT"
      }
      "to" = {
        "resources" = ["*"]
        "operations" = {
          "monitoring.googleapis.com" = {
            "methods" = ["*"]
          },
          "logging.googleapis.com" = {
            "methods" = ["*"]
          },
          "artifactregistry.googleapis.com" = {
            "methods" = ["*"]
          }
        }
      }
    },
  ]
  egress_policies = []
}

resource "null_resource" "wait_for_members" {
  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [module.access_level_admins]
}