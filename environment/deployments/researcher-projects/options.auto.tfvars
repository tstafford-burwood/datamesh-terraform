#------------------------------------
# RESEARCHER WORKSPACE PROJECT TFVARS
#------------------------------------

// RESEARCHER WORKSPACE TFVARS - OPTIONAL
workspace_default_service_account = "keep"

#--------------------------------------
# GOOGLE CLOUD SOURCE REPOSITORY TFVARS
#--------------------------------------

workspace_cloud_source_repo_name = "workspace_cloud_source_repo"

#-------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM MEMBER BINDING TFVARS
#-------------------------------------------------------

# TODO: Update IAM permissions for researchers

workspace_project_iam_role_list = [
  "roles/compute.osLogin",
  "roles/iam.serviceAccountUser",
  "roles/iap.tunnelResourceAccessor"
]

#--------------------------------
# RESEARCHER WORKSPACE VPC TFVARS
#--------------------------------

workspace_vpc_delete_default_internet_gateway_routes = true
workspace_vpc_firewall_rules                         = []
workspace_vpc_routing_mode                           = "GLOBAL"
workspace_vpc_mtu                                    = 1460

workspace_vpc_routes = [
  {
    name              = "srde-private-google-apis-and-iap-tunnel-custom-route"
    description       = "Custom VPC Route for Private Google API and IAP tunnel access."
    tags              = "deep-learning-vm"
    destination_range = "199.36.153.8/30"
    next_hop_internet = "true"
    priority          = 10
  },
  # {
  #   name              = "srde-private-google-apis-custom-route"
  #   description       = "Custom VPC Route for Private Google API."
  #   tags              = "path-ml-vm"
  #   destination_range = "199.36.153.8/30"
  #   next_hop_internet = "true"
  #   priority          = 10
  # },
  {
    name              = "deep-learning-vm-ping-8-8-8-8"
    description       = "Custom VPC Route used to ping 8.8.8.8/32"
    tags              = "deep-learning-vm"
    destination_range = "8.8.8.8/32"
    next_hop_internet = "true"
    priority          = 20
  },
  # {
  #   name              = "path-ml-vm-ping-8-8-8-8"
  #   description       = "Custom VPC Route used to ping 8.8.8.8/32"
  #   tags              = "path-ml-vm"
  #   destination_range = "8.8.8.8/32"
  #   next_hop_internet = "true"
  #   priority          = 30
  # }
]

#-----------------------------------------------------
# RESEARCHER WORKSPACE RESTRICTED API CLOUD DNS TFVARS
#-----------------------------------------------------

// REQUIRED TFVARS
workspace_restricted_api_cloud_dns_domain = "googleapis.com."
workspace_restricted_api_cloud_dns_name   = "srde-private-google-apis-private-zone"

// OPTIONAL TFVARS
workspace_restricted_api_default_key_specs_key  = {}
workspace_restricted_api_default_key_specs_zone = {}
workspace_restricted_api_cloud_dns_description  = "Private DNS Zone for mapping calls for private.googleapis.com to Virtual IP addresses in the SRDE."
workspace_restricted_api_dnssec_config          = {}
workspace_restricted_api_cloud_dns_labels       = { "restricted-google-api-private-zone" : "group1" }
workspace_restricted_api_cloud_dns_recordsets = [
  {
    name    = "*"
    type    = "CNAME"
    ttl     = 300
    records = ["private.googleapis.com."]
  },
  {
    name = "private"
    type = "A"
    ttl  = 300
    records = [
      "199.36.153.8",
      "199.36.153.9",
      "199.36.153.10",
      "199.36.153.11"
    ]
  }
]
workspace_restricted_api_target_name_server_addresses = []
workspace_restricted_api_cloud_dns_target_network     = ""
workspace_restricted_api_cloud_dns_zone_type          = "private"

#-------------------------------------------------
# RESEARCHER WORKSPACE IAP TUNNEL CLOUD DNS TFVARS
#-------------------------------------------------

// REQUIRED TFVARS
workspace_iap_tunnel_cloud_dns_domain = "tunnel.cloudproxy.app."
workspace_iap_tunnel_cloud_dns_name   = "srde-iap-tunnel-private-zone"

// OPTIONAL TFVARS
workspace_iap_tunnel_default_key_specs_key  = {}
workspace_iap_tunnel_default_key_specs_zone = {}
workspace_iap_tunnel_cloud_dns_description  = "Private DNS Zone that enables IAP connections to be established from inside of a GCP VM so that an SSH connection to another VM can be made."
workspace_iap_tunnel_dnssec_config          = {}
workspace_iap_tunnel_cloud_dns_labels       = { "iap-tunnel-private-zone" : "group1" }
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
      "199.36.153.8",
      "199.36.153.9",
      "199.36.153.10",
      "199.36.153.11"
    ]
  }
]
workspace_iap_tunnel_target_name_server_addresses = []
workspace_iap_tunnel_cloud_dns_target_network     = ""
workspace_iap_tunnel_cloud_dns_zone_type          = "private"

#--------------------------------------------------------
# RESEARCHER WORKSPACE ARTIFACT REGISTRY CLOUD DNS TFVARS
#--------------------------------------------------------

// REQUIRED TFVARS
workspace_artifact_registry_cloud_dns_domain = "pkg.dev."
workspace_artifact_registry_cloud_dns_name   = "srde-artifact-registry-private-zone"

// OPTIONAL TFVARS
workspace_artifact_registry_default_key_specs_key  = {}
workspace_artifact_registry_default_key_specs_zone = {}
workspace_artifact_registry_cloud_dns_description  = "Private DNS Zone that enables access to Artifact Registry domain."
workspace_artifact_registry_dnssec_config          = {}
workspace_artifact_registry_cloud_dns_labels       = { "artifact-registry-private-zone" : "group1" }
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
      "199.36.153.8",
      "199.36.153.9",
      "199.36.153.10",
      "199.36.153.11"
    ]
  }
]
workspace_artifact_registry_target_name_server_addresses = []
workspace_artifact_registry_cloud_dns_target_network     = ""
workspace_artifact_registry_cloud_dns_zone_type          = "private"

#-----------------------------------------
# WORKSPACE FIREWALL
#-----------------------------------------

workspace_firewall_custom_rules = {
  deep-learning-vm-allow-egress-to-private-google-apis = {
    description          = "Allow egress from Deep Learning Workspace VM to Private Google APIs Virtual IP."
    direction            = "EGRESS"
    action               = "allow"
    ranges               = ["199.36.153.8/30"]
    sources              = []
    targets              = ["deep-learning-vm"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["443"]
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 5
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  # path-ml-vm-allow-egress-to-private-google-apis = {
  #   description          = "Allow egress from Path ML Workspace VM to Private Google APIs Virtual IP."
  #   direction            = "EGRESS"
  #   action               = "allow"
  #   ranges               = ["199.36.153.8/30"]
  #   sources              = []
  #   targets              = ["path-ml-vm"]
  #   use_service_accounts = false
  #   rules = [
  #     {
  #       protocol = "tcp"
  #       ports    = ["443"]
  #     }
  #   ]
  #   extra_attributes = {
  #     "disabled" : false
  #     "priority" : 5
  #   }
  #   flow_logs_metadata = "INCLUDE_ALL_METADATA"
  # },
  deep-learning-vm-allow-8-8-8-8-icmp = {
    description          = "Allow Deep Learning Workspace VM to ping 8.8.8.8/32."
    direction            = "EGRESS"
    action               = "allow"
    ranges               = ["8.8.8.8/32"]
    sources              = []
    targets              = ["deep-learning-vm"]
    use_service_accounts = false
    rules = [
      {
        protocol = "icmp"
        ports    = []
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 10
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  # path-ml-vm-allow-8-8-8-8-icmp = {
  #   description          = "Allow Path ML Workspace VM to ping 8.8.8.8/32."
  #   direction            = "EGRESS"
  #   action               = "allow"
  #   ranges               = ["8.8.8.8/32"]
  #   sources              = []
  #   targets              = ["path-ml-vm"]
  #   use_service_accounts = false
  #   rules = [
  #     {
  #       protocol = "icmp"
  #       ports    = []
  #     }
  #   ]
  #   extra_attributes = {
  #     "disabled" : false
  #     "priority" : 10
  #   }
  #   flow_logs_metadata = "INCLUDE_ALL_METADATA"
  # },
  all-workspace-vm-deny-all-other-egress = {
    description          = "Block all other egress from any VM in the Workspace project."
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
      "priority" : 50
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  deep-learning-vm-allow-ssh-ingress-from-bastion = {
    description          = "Allow SSH connection into Workspace VM."
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["10.10.0.2/32"]
    sources              = ["bastion-vm"]
    targets              = ["deep-learning-vm"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["22"]
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 5
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
      "priority" : 40
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  # path-ml-vm-ingress-ssh-from-deep-learning-vm = {
  #   description          = "Allow ingress to path ml vm from deep learning vm."
  #   direction            = "INGRESS"
  #   action               = "allow"
  #   ranges               = []
  #   sources              = ["deep-learning-vm"]
  #   targets              = ["path-ml-vm"]
  #   use_service_accounts = false
  #   rules = [
  #     {
  #       protocol = "tcp"
  #       ports    = ["22"]
  #     }
  #   ]
  #   extra_attributes = {
  #     "disabled" : false
  #     "priority" : 5
  #   }
  #   flow_logs_metadata = "INCLUDE_ALL_METADATA"
  # },
  # deep-learning-vm-ssh-egress-to-path-ml-vm = {
  #   description          = "Allow egress from deep learning vm to path ml vm"
  #   direction            = "EGRESS"
  #   action               = "allow"
  #   ranges               = ["10.0.0.3/32"]
  #   sources              = []
  #   targets              = ["deep-learning-vm"]
  #   use_service_accounts = false
  #   rules = [
  #     {
  #       protocol = "tcp"
  #       ports    = ["22"]
  #     }
  #   ]
  #   extra_attributes = {
  #     "disabled" : false
  #     "priority" : 5
  #   }
  #   flow_logs_metadata = "INCLUDE_ALL_METADATA"
  # },
  # allow-iap-ingress-to-pathml-container = {
  #   description          = "Allow IAP ingress to the path ml JupyterLab container."
  #   direction            = "INGRESS"
  #   action               = "allow"
  #   ranges               = ["35.235.240.0/20"]
  #   sources              = []
  #   targets              = ["path-ml-vm"]
  #   use_service_accounts = false
  #   rules = [
  #     {
  #       protocol = "tcp"
  #       ports    = ["8888"]
  #     }
  #   ]
  #   extra_attributes = {
  #     "disabled" : false
  #     "priority" : 10
  #   }
  #   flow_logs_metadata = "INCLUDE_ALL_METADATA"
  # },
  # allow-egress-pathml-container = {
  #   description          = "Allow egress from the path ml JupyterLab container."
  #   direction            = "EGRESS"
  #   action               = "allow"
  #   ranges               = ["0.0.0.0/0"]
  #   sources              = []
  #   targets              = ["path-ml-vm"]
  #   use_service_accounts = false
  #   rules = [
  #     {
  #       protocol = "tcp"
  #       ports    = ["8888"]
  #     }
  #   ]
  #   extra_attributes = {
  #     "disabled" : false
  #     "priority" : 10
  #   }
  #   flow_logs_metadata = "INCLUDE_ALL_METADATA"
  # }
}

#-------------------------------------------------------------
# RESEARCHER WORKSPACE DEEP LEARNING VM SERVICE ACCOUNT TFVARS
#-------------------------------------------------------------

// OPTIONAL TFVARS

workspace_deeplearning_vm_sa_description           = "Researcher Workspace Project VM Service Account"
workspace_deeplearning_vm_sa_display_name          = "Terraform-managed service account"
workspace_deeplearning_vm_sa_service_account_names = ["group1-deeplearning-vm-sa"] // CHANGE WITH EACH NEW PROJECT

#----------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM CUSTOM ROLE TFVARS
#----------------------------------------------------

workspace_project_iam_custom_role_description = "Custom SRDE Role for Workspace project operations."
workspace_project_iam_custom_role_id          = "srdeCustomRoleWorkspaceProjectOperations"
workspace_project_iam_custom_role_title       = "[Custom] SRDE Workspace Project Operations Role"
workspace_project_iam_custom_role_permissions = ["storage.buckets.list", "storage.objects.list", "storage.objects.get", "storage.objects.create"] # TODO: Update this if needed.
workspace_project_iam_custom_role_stage       = "GA"

#-------------------------------------------------------
# RESEARCHER WORKSPACE DEEPLEARNING VM PRIVATE IP TFVARS
#-------------------------------------------------------

workspace_deeplearning_vm_allow_stopping_for_update = true
workspace_deeplearning_vm_description               = "Workspace VM created with Terraform"
workspace_deeplearning_vm_desired_status            = "RUNNING"
workspace_deeplearning_vm_deletion_protection       = false

workspace_deeplearning_vm_labels = {
  "researcher1" : "deeplearning-vm" // CHANGE WITH EACH NEW PROJECT
}

workspace_deeplearning_vm_metadata = {
  "enable-oslogin" : "TRUE"
}

workspace_deeplearning_vm_machine_type     = "n2-standard-4"
workspace_deeplearning_vm_name             = "deep-learning-vm1"
workspace_deeplearning_vm_tags             = ["deep-learning-vm"]
workspace_deeplearning_vm_auto_delete_disk = true

// NETWORK INTERFACE

workspace_deeplearning_vm_network_ip = "10.0.0.2"

// SERVICE ACCOUNT

workspace_deeplearning_vm_service_account_scopes = ["compute-rw"]

// SHIELDED INSTANCE CONFIG

workspace_deeplearning_vm_enable_secure_boot          = true
workspace_deeplearning_vm_enable_vtpm                 = true
workspace_deeplearning_vm_enable_integrity_monitoring = true

#-----------------------------------
# RESEARCHER WORKSPACE - REGIONAL EXTERNAL STATIC IP TFVARS
#-----------------------------------

// OPTIONAL
researcher_workspace_regional_external_static_ip_address_type = "EXTERNAL"
researcher_workspace_regional_external_static_ip_description  = "Regional External Static IP for Researcher Workspace to use with Cloud NAT."
researcher_workspace_regional_external_static_ip_network_tier = "PREMIUM"

#----------------------------------------
# RESEARCHER WORKSPACE - CLOUD NAT TFVARS
#----------------------------------------

researcher_workspace_create_router                       = true
researcher_workspace_router_asn                          = "64514"
researcher_workspace_enable_endpoint_independent_mapping = null
researcher_workspace_icmp_idle_timeout_sec               = "30"
researcher_workspace_log_config_enable                   = true
researcher_workspace_log_config_filter                   = "ALL"
researcher_workspace_min_ports_per_vm                    = "64"
researcher_workspace_source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"
researcher_workspace_tcp_established_idle_timeout_sec    = "1200"
researcher_workspace_tcp_transitory_idle_timeout_sec     = "30"
researcher_workspace_udp_idle_timeout_sec                = "30"

#----------------------------------
# RESEARCHER BASTION PROJECT TFVARS
#----------------------------------

// RESEARCHER BASTION TFVARS - OPTIONAL
bastion_project_activate_apis = [
  "compute.googleapis.com",
  "serviceusage.googleapis.com",
  "oslogin.googleapis.com",
  "iap.googleapis.com",
  "osconfig.googleapis.com"
]

bastion_project_default_service_account = "delete"
bastion_project_lien                    = false
bastion_project_labels = {
  "researcher1-project" : "bastion-project" // CHANGE LABEL WITH EACH NEW PROJECT
}

#------------------------------------------------------
# RESEARCHER BASTION PROJECT IAM MEMBER BINDING TFVARS
#------------------------------------------------------

bastion_project_iam_role_list = [
  "roles/browser",
  "roles/compute.osLogin",
  "roles/iap.tunnelResourceAccessor",
  "roles/iam.serviceAccountUser"
]

#--------------------------------------------------
# RESEARCHER BASTION PROJECT IAM CUSTOM ROLE TFVARS
#--------------------------------------------------

bastion_project_iam_custom_role_description = "Custom SRDE Role for Bastion project operations."
bastion_project_iam_custom_role_id          = "srdeCustomRoleBastionProjectOperations"
bastion_project_iam_custom_role_title       = "[Custom] SRDE Bastion Project Operations Role"
bastion_project_iam_custom_role_permissions = ["compute.instances.list", "compute.instances.get"]
bastion_project_iam_custom_role_stage       = "GA"

#--------------------------------------
# RESEARCHER BASTION PROJECT VPC TFVARS
#--------------------------------------

bastion_project_vpc_delete_default_internet_gateway_routes = true
bastion_project_vpc_mtu                                    = 1460

# bastion_project_vpc_subnets = [
# {
#    subnet_name               = "bastion-vpc-subnet"
#    subnet_ip                 = "11.0.0.0/16"
##    subnet_region             = "us-central1"
#    subnet_flow_logs          = "true"
#    subnet_flow_logs_interval = "INTERVAL_10_MIN"
##    subnet_flow_logs_sampling = 0.7
#    subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
#    subnet_private_access     = "true"
#  }
#]

bastion_project_vpc_routes = [
  {
    name              = "sde-ping-8-8-8-8"
    description       = "Custom VPC Route used to ping 8.8.8.8/32"
    tags              = "bastion-vm"
    destination_range = "8.8.8.8/32"
    next_hop_internet = "true"
    priority          = 20
  }
]

#-----------------------------------------------
# RESEARCHER BASTION PROJECT VPC FIREWALL TFVARS
#-----------------------------------------------

bastion_project_firewall_custom_rules = {
  bastion-vm-allow-ssh-from-iap-tunnel = {
    description          = "Allow SSH ingress from IAP tunnel."
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["35.235.240.0/20"]
    sources              = []
    targets              = ["allow-iap"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["22"]
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 5
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  bastion-vm-deny-all-other-ingress = {
    description          = "Deny all other ingress to any VM."
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
      "priority" : 10
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  bastion-vm-allow-ssh-egress-to-deep-learning-vm = {
    description          = "Only allow SSH egress to Deep Learning VM."
    direction            = "EGRESS"
    action               = "allow"
    ranges               = ["10.0.0.2/32"]
    sources              = []
    targets              = ["bastion-vm"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["22"]
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 5
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  bastion-vm-allow-8-8-8-8-icmp = {
    description          = "Allow egress to ping 8.8.8.8/32"
    direction            = "EGRESS"
    action               = "allow"
    ranges               = ["8.8.8.8/32"]
    sources              = []
    targets              = ["bastion-vm"]
    use_service_accounts = false
    rules = [
      {
        protocol = "icmp"
        ports    = []
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 40
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  bastion-vm-deny-all-other-egress = {
    description          = "Deny all other egress from any VM in project."
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
      "priority" : 50
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  }
}

#-----------------------------------------------------
# RESEARCHER BASTION PROJECT VM SERVICE ACCOUNT TFVARS
#-----------------------------------------------------

// OPTIONAL TFVARS

bastion_project_sa_service_account_names = ["researcher-bastion-vm-sa"] // CHANGE WITH EACH NEW PROJECT

#-----------------------------------------------------------------------
# RESEARCHER BASTION VM SERVICE ACCOUNT PROJECT IAM MEMBER MODULE TFVARS
#-----------------------------------------------------------------------

bastion_vm_sa_project_iam_role_list = []

#----------------------------------------
# RESEARCHER BASTION VM PRIVATE IP TFVARS
#----------------------------------------

bastion_vm_allow_stopping_for_update = true
bastion_vm_description               = "Bastion VM created with Terraform"
bastion_vm_desired_status            = "RUNNING"
bastion_vm_deletion_protection       = false

bastion_vm_labels = {
  "researcher1" : "bastion-vm" // CHANGE WITH EACH NEW PROJECT
}

bastion_vm_metadata = {
  "enable-oslogin" : "TRUE"
}

bastion_vm_machine_type     = "n2-standard-4"
bastion_vm_name             = "bastion-vm-cis-rhel1"
bastion_vm_tags             = ["allow-iap", "bastion-vm"] // NETWORK TAG APPLIED TO VM FOR FIREWALL FILTERING AND USED WITH IAP FW RULE
bastion_vm_auto_delete_disk = true

// NETWORK INTERFACE

bastion_vm_network_ip = "10.10.0.2"

// SERVICE ACCOUNT

bastion_vm_service_account_scopes = []

// SHIELDED INSTANCE CONFIG

bastion_vm_enable_secure_boot          = true
bastion_vm_enable_vtpm                 = true
bastion_vm_enable_integrity_monitoring = true

#-----------------------------------------------------
# BASTION PROJECT - REGIONAL EXTERNAL STATIC IP TFVARS
#-----------------------------------------------------
// OPTIONAL

bastion_project_regional_external_static_ip_description = "Regional External Static IP for Bastion Project to use with Cloud NAT."

#----------------------------------------
# BASTION PROJECT - CLOUD NAT TFVARS
#----------------------------------------

bastion_project_router_asn                          = "64514"
bastion_project_enable_endpoint_independent_mapping = null
bastion_project_icmp_idle_timeout_sec               = "30"
bastion_project_log_config_enable                   = true
bastion_project_log_config_filter                   = "ALL"
bastion_project_min_ports_per_vm                    = "64"
bastion_project_source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"
bastion_project_tcp_established_idle_timeout_sec    = "1200"
bastion_project_tcp_transitory_idle_timeout_sec     = "30"
bastion_project_udp_idle_timeout_sec                = "30"

#-----------
# IAP TFVARS
#-----------

// FIREWALL RULE BEING MADE IN BASTION VPC FIREWALL MODULE TFVARS

instances                  = []
iap_members                = []
additional_ports           = []
create_firewall_rule       = false
fw_name_allow_ssh_from_iap = "allow-ssh-from-iap-to-tunnel"
host_project               = ""

#--------------------------------------
# RESEARCHER DATA EGRESS PROJECT TFVARS
#--------------------------------------

// RESEARCHER DATA EGRESS PROJECT TFVARS - OPTIONAL

egress_default_service_account = "disable"

#--------------------------------
# PUB/SUB GCS NOTIFICATION TFVARS
#--------------------------------

// REQUIRED TFVARS

payload_format     = "JSON_API_V1"
pub_sub_topic_name = "secure-staging-project-topic"

// OPTIONAL TFVARS

custom_attributes = { "pubsub" : "gcs_bucket" }

event_types = [
  "OBJECT_FINALIZE",
  "OBJECT_METADATA_UPDATE",
  "OBJECT_DELETE",
  "OBJECT_ARCHIVE"
]

object_name_prefix = null

#--------------------------------
# PUB/SUB TOPIC IAM MEMBER TFVARS
#--------------------------------

topic_name = "secure-staging-project-topic"
role       = "roles/pubsub.publisher"

#-----------------------------------------------------------------
# BIGQUERY DATASET - RESEARCHER DLP RESULTS STAGING PROJECT TFVARS
#-----------------------------------------------------------------

// OPTIONAL TFVARS

bq_researcher_dlp_bigquery_access              = []
bq_researcher_dlp_dataset_labels               = { "group1_name" : "dlp_dataset" } // CHANGE WITH EACH NEW PROJECT
bq_researcher_dlp_default_table_expiration_ms  = null
bq_researcher_dlp_delete_contents_on_destroy   = true
bq_researcher_dlp_bigquery_deletion_protection = false
bq_researcher_dlp_bigquery_description         = "BigQuery Dataset created with Terraform for DLP scan results."
bq_researcher_dlp_encryption_key               = null
bq_researcher_dlp_external_tables              = []
bq_researcher_dlp_location                     = "US"
bq_researcher_dlp_routines                     = []
bq_researcher_dlp_tables                       = []
bq_researcher_dlp_views                        = []

#-------------------------------------------------------
# BIGQUERY DATASET - RESEARCHER WORKSPACE DATASET TFVARS
#-------------------------------------------------------

// OPTIONAL TFVARS

bq_workspace_bigquery_access              = []
bq_workspace_dataset_labels               = { "group1_name" : "workspace_dataset" } // CHANGE WITH EACH NEW PROJECT
bq_workspace_default_table_expiration_ms  = null
bq_workspace_delete_contents_on_destroy   = true
bq_workspace_bigquery_deletion_protection = false
bq_workspace_bigquery_description         = "BigQuery Dataset created with Terraform for Workspace VMs to access."
bq_workspace_encryption_key               = null
bq_workspace_external_tables              = []
bq_workspace_location                     = "US"
bq_workspace_routines                     = []
bq_workspace_tables                       = []
bq_workspace_views                        = []

#----------------------------------------------------
# VPC SC RESEARCHER GROUP MEMBER ACCESS LEVELS TFVARS
#----------------------------------------------------

// OPTIONAL TFVARS - NON PREMIUM

# combining_function       = "OR"
# access_level_description = "Researcher Group 1 Access Level"
# ip_subnetworks           = []

# negate                 = false
# regions                = []
# required_access_levels = []

// OPTIONAL TFVARS - DEVICE POLICY (PREMIUM)

# allowed_device_management_levels = []
# allowed_encryption_statuses      = []
# minimum_version                  = ""
# os_type                          = "OS_UNSPECIFIED"
#require_corp_owned               = false
#require_screen_lock = false

#-----------------------------------------------------
# RESEARCHER WORKSPACE VPC SC REGULAR PERIMETER TFVARS
#-----------------------------------------------------

// REQUIRED TFVARS

researcher_workspace_regular_service_perimeter_description = "Group 1 Workspace Regular Service Perimeter" // CHANGE WITH EACH NEW PROJECT

// OPTIONAL TFVARS

researcher_workspace_regular_service_perimeter_enable_restriction = true
researcher_workspace_regular_service_perimeter_allowed_services = [
  "storage.googleapis.com",
  "bigquery.googleapis.com",
  "compute.googleapis.com",
  "oslogin.googleapis.com",
  "iaptunnel.googleapis.com",
  "artifactregistry.googleapis.com",
]

#----------------------------------------------------------------------
# RESEARCHER WORKSPACE & STAGING PROJECT VPC SC BRIDGE PERIMETER TFVARS 
#----------------------------------------------------------------------

// OPTIONAL TFVARS

workspace_and_staging_bridge_service_perimeter_description = "Bridge Perimeter between Group 1 Workspace Project and Secure Staging Project." // CHANGE WITH EACH NEW PROJECT

#----------------------------------------------------------------------
# RESEARCHER WORKSPACE & DATA LAKE PROJECT VPC SC BRIDGE PERIMETER TFVARS 
#----------------------------------------------------------------------

// OPTIONAL TFVARS

workspace_and_data_lake_bridge_service_perimeter_description = "Bridge Perimeter between Group 1 Workspace Project and Data Lake project." // CHANGE WITH EACH NEW PROJECT

#-----------------------------------------------------------
# RESEARCHER BASTION PROJECT VPC SC REGULAR PERIMETER TFVARS
#-----------------------------------------------------------

// REQUIRED TFVARS

researcher_bastion_project_regular_service_perimeter_description = "Group 1 Bastion Project Regular Service Perimeter" // CHANGE WITH EACH NEW PROJECT

// OPTIONAL TFVARS

researcher_bastion_project_regular_service_perimeter_enable_restriction = true
researcher_bastion_project_regular_service_perimeter_allowed_services   = []

#----------------------------------------------------------------------------
# RESEARCHER EXTERNAL EGRESS & STAGING PROEJCT VPC SC BRIDGE PERIMETER TFVARS
#----------------------------------------------------------------------------

// OPTIONAL TFVARS

external_egress_and_staging_bridge_service_perimeter_description = "Bridge Perimeter between Group 1 External Data Egress Project and Secure Staging Project." // CHANGE WITH EACH NEW PROJECT