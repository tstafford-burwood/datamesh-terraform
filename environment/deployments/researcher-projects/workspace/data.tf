#----------------------------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------------------------

module "constants" {
  source = "../../../foundation/constants"
}

#----------------------------------------------------------------------------------------------
# TERRAFORM STATE IMPORTS
#----------------------------------------------------------------------------------------------

data "terraform_remote_state" "image_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/image"
  }
}

data "terraform_remote_state" "staging_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ops"
  }
}

data "terraform_remote_state" "cloud_composer" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/cloud-composer"
  }
}

data "terraform_remote_state" "notebook_sa" {
  # Get the Notebook Service Account from TFSTATE
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ops"
  }
}

data "terraform_remote_state" "data_ingress" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ingress"
  }
}

data "terraform_remote_state" "datalake_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-lake"
  }
}

data "terraform_remote_state" "folders" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/folders"
  }
}

data "terraform_remote_state" "vpc_sc" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/vpc-sc"
  }
}

data "terraform_remote_state" "egress_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "deployments/${terraform.workspace}/researcher-projects/${var.researcher_workspace_name}/egress"
  }
}

# data "google_compute_image" "deep_learning_image" {
#   # If family is specified, will return latest image that is part of image family
#   count   = var.num_instances
#   project = local.imaging_project_id
#   family  = "packer-data-science"
# }

locals {
  environment                = module.constants.value.environment
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  org_id                     = module.constants.value.org_id
  billing_account_id         = var.billing_account
  srde_folder_id             = data.terraform_remote_state.folders.outputs.ids[var.researcher_workspace_name]
  staging_project_id         = data.terraform_remote_state.staging_project.outputs.staging_project_id
  staging_project_number     = data.terraform_remote_state.staging_project.outputs.staging_project_number
  data_ops_bucket            = data.terraform_remote_state.staging_project.outputs.research_to_bucket
  cordon_bucket              = data.terraform_remote_state.staging_project.outputs.csv_names_list[0]
  pubsub_appint_approval     = data.terraform_remote_state.staging_project.outputs.pubsub_trigger_appint_approval
  pubsub_appint_results      = data.terraform_remote_state.staging_project.outputs.pubsub_trigger_appint_results
  data_ingress               = try(data.terraform_remote_state.data_ingress.outputs.project_number, "")
  data_ingress_id            = try(data.terraform_remote_state.data_ingress.outputs.project_id, "")
  data_ingress_bucket        = data.terraform_remote_state.data_ingress.outputs.bucket_names
  data_lake                  = try(data.terraform_remote_state.datalake_project.outputs.data_lake_project_number, "")
  data_lake_id               = try(data.terraform_remote_state.datalake_project.outputs.data_lake_project_id, "")
  data_lake_bucket           = data.terraform_remote_state.datalake_project.outputs.research_to_bucket
  data_lake_custom_role      = data.terraform_remote_state.datalake_project.outputs.bucket_list_custom_role_name
  composer_sa                = try(data.terraform_remote_state.staging_project.outputs.email, "")
  dag_bucket                 = data.terraform_remote_state.cloud_composer.outputs.dag_bucket_name
  workspace_project_id       = module.workspace_project.project_id
  researcher_workspace_name  = lower(var.researcher_workspace_name)
  region                     = var.region
  imaging_project_id         = data.terraform_remote_state.image_project.outputs.project_id
  apt_repo_name              = data.terraform_remote_state.image_project.outputs.apt_repo_name
  notebook_sa                = try(data.terraform_remote_state.notebook_sa.outputs.notebook_sa_email, "")
  egress                     = try(data.terraform_remote_state.egress_project.outputs.project_number, "")
  imaging_bucket             = data.terraform_remote_state.image_project.outputs.research_to_bucket


  define_trusted_image_projects = [
    "projects/deeplearning-platform-release",
    "projects/${local.imaging_project_id}"
  ]

  # Get VPC Service Control Access Context Manager for Admins, Stewards and Service Accounts
  parent_access_policy_id = try(data.terraform_remote_state.vpc_sc.outputs.parent_access_policy_id, "")
  fdn_admins              = try(data.terraform_remote_state.vpc_sc.outputs.admin_access_level_name, "")
  fdn_sa                  = try(data.terraform_remote_state.vpc_sc.outputs.serviceaccount_access_level_name, "")
  fnd_stewards            = try(data.terraform_remote_state.vpc_sc.outputs.stewards_access_level_name, "")

  # drop the prefix `user` from each steward value to create a string of email addresses
  trim_prefix    = [for steward in var.data_stewards : trimprefix(steward, "user:")] # drop the `user:` prefix
  steward_emails = join(",", local.trim_prefix)

  policy_for = "project"

  workspace_vpc_routes = [
    {
      name              = "tagged-restricted-vip-route"
      description       = "Custom VPC Route for Restricted Google API."
      tags              = "jupyter-notebook"
      destination_range = "0.0.0.0/0"
      next_hop_internet = "true"
      priority          = 1000
    },
  ]

  workspace_firewall_custom_rules = {
    allow-egress-to-private-google-apis = {
      description          = "Allow egress from VMs to Private Google APIs."
      direction            = "EGRESS"
      action               = "allow"
      ranges               = ["199.36.153.8/30", "199.36.153.4/30"]
      sources              = []
      targets              = ["deep-learning-vm", "notebook-instance"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = ["443"]
        }
      ]
      extra_attributes = {
        "disabled" : false
        "priority" : 50
      }
      flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    allow-ingress-to-notebook-port = {
      description          = "Allow external ingress to Deep Learning Jupyter Notebook port."
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["0.0.0.0/0"]
      sources              = []
      targets              = ["jupyter-notebook"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = ["8080"]
        }
      ]
      extra_attributes = {
        "disabled" : false
        "priority" : 100
      }
      flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    deny-all-egress = {
      description          = "Block all egress traffic."
      direction            = "EGRESS"
      action               = "deny"
      ranges               = ["0.0.0.0/0"]
      sources              = []
      targets              = []
      use_service_accounts = false
      rules = [
        {
          protocol = "all"
          ports    = []
        }
      ]
      extra_attributes = {
        "disabled" : false
        "priority" : 900
      }
      flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    all-workspace-vm-deny-all-other-ingress = {
      description          = "Deny all other ingress to any Workspace VMs."
      direction            = "INGRESS"
      action               = "deny"
      ranges               = ["0.0.0.0/0"]
      sources              = []
      targets              = []
      use_service_accounts = false
      rules = [
        {
          protocol = "all"
          ports    = []
        }
      ]
      extra_attributes = {
        "disabled" : false
        "priority" : 800
      }
      flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
  }

  workspace_restricted_api_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["restricted.googleapis.com."]
    },
    {
      name = "restricted"
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]

  workspace_iap_tunnel_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["tunnel.cloudproxy.app."]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]

  workspace_container_registry_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["gcr.io."]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]

  workspace_artifact_registry_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["pkg.dev."]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]

  workspace_notebook_api_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["*.notebooks.googleapis.com."]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]

  workspace_notebook_cloud_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["*.notebooks.cloud.google.com."]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]

  workspace_notebook_usercontent_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["*.notebooks.googleusercontent.com."]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]
}