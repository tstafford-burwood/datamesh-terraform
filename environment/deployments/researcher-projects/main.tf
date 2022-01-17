#----------------------------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------------------------

module "constants" {
  source = "../../foundation/constants"
}

#----------------------------------------------------------------------------------------------
# DATA BLOCKS
# Retrieve Staging project state
#----------------------------------------------------------------------------------------------

data "terraform_remote_state" "staging_project" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "deployments/staging-project"
  }
}

#----------------------------------------------------------------------------------------------
# SET CONSTANT MODULE VALUES AS LOCALS
#----------------------------------------------------------------------------------------------

locals {
  staging_project_id        = data.terraform_remote_state.staging_project.outputs.staging_project_id
  staging_project_number    = data.terraform_remote_state.staging_project.outputs.staging_project_number
  org_id                    = module.constants.value.org_id
  billing_account_id        = module.constants.value.billing_account_id
  srde_folder_id            = module.constants.value.srde_folder_id
  workspace_default_region  = module.constants.value.workspace_default_region
  bastion_default_region    = module.constants.value.bastion_default_region
  staging_default_region    = module.constants.value.staging_default_region
  researcher_workspace_name = var.researcher_workspace_name
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE - PROJECT
# Create the Workspace Project
#----------------------------------------------------------------------------------------------

module "workspace_project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = format("%s-%s", local.researcher_workspace_name, "workspace")
  org_id             = local.org_id
  billing_account_id = local.billing_account_id
  folder_id          = local.srde_folder_id

  // OPTIONAL FIELDS
  activate_apis = [
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "oslogin.googleapis.com",
    "iap.googleapis.com",
    "bigquery.googleapis.com",
    "dns.googleapis.com",
    "tpu.googleapis.com",
    "sourcerepo.googleapis.com",
    "osconfig.googleapis.com"
  ]
  auto_create_network         = false
  random_project_id           = true
  lien                        = false
  create_project_sa           = false
  default_service_account     = var.workspace_default_service_account
  disable_dependent_services  = true
  disable_services_on_destroy = true
  project_labels = {
    "researcher-workspace" : "${local.researcher_workspace_name}-workspace-project"
  }
}

resource "google_compute_project_metadata" "researcher_workspace_project" {
  project = module.workspace_project.project_id
  metadata = {
    enable-osconfig = "TRUE",
    enable-oslogin  = "TRUE"
  }
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE - IAM MEMBER BINDING
#----------------------------------------------------------------------------------------------

module "workspace_project_iam_member" {
  source = "../../../modules/iam/project_iam"

  project_id            = module.workspace_project.project_id
  project_member        = var.workspace_project_member
  project_iam_role_list = var.workspace_project_iam_role_list
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE - DEEPLEARNING VM SERVICE ACCOUNT
#----------------------------------------------------------------------------------------------

module "workspace_deeplearning_vm_service_account" {

  source = "../../../modules/service_account"

  project_id            = module.workspace_project.project_id
  billing_account_id    = local.billing_account_id
  description           = "Terraform-managed service account"
  display_name          = var.workspace_deeplearning_vm_sa_display_name
  service_account_names = var.workspace_deeplearning_vm_sa_service_account_names
  org_id                = local.org_id
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE - PROJECT IAM CUSTOM ROLE MODULE
#----------------------------------------------------------------------------------------------

module "workspace_project_iam_custom_role" {
  source = "../../../modules/iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.workspace_project.project_id
  project_iam_custom_role_description = var.workspace_project_iam_custom_role_description
  project_iam_custom_role_id          = var.workspace_project_iam_custom_role_id
  project_iam_custom_role_title       = var.workspace_project_iam_custom_role_title
  project_iam_custom_role_permissions = var.workspace_project_iam_custom_role_permissions
  project_iam_custom_role_stage       = var.workspace_project_iam_custom_role_stage
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE VM SERVICE ACCOUNT - PROJECT IAM MEMBER CUSTOM SRDE ROLE
#----------------------------------------------------------------------------------------------

resource "google_project_iam_member" "workspace_project_custom_srde_role" {

  project = module.workspace_project.project_id
  role    = module.workspace_project_iam_custom_role.name
  member  = var.workspace_project_member // CURRENTLY SET TO USERS/GROUPS DEFINED IN TFVARS
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE - VPC
# Create the VPC in the Workspace Project
#----------------------------------------------------------------------------------------------

module "workspace_vpc" {
  source = "../../../modules/vpc"

  project_id                             = module.workspace_project.project_id
  vpc_network_name                       = format("%s-%s", local.researcher_workspace_name, "workspace-vpc")
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = var.workspace_vpc_delete_default_internet_gateway_routes
  firewall_rules                         = var.workspace_vpc_firewall_rules
  routing_mode                           = var.workspace_vpc_routing_mode
  vpc_description                        = var.workspace_vpc_description
  shared_vpc_host                        = var.workspace_vpc_shared_vpc_host
  mtu                                    = var.workspace_vpc_mtu

  subnets = [
    {
      subnet_name               = "${local.researcher_workspace_name}-${local.workspace_default_region}-workspace-subnet"
      subnet_ip                 = "10.0.0.0/16"
      subnet_region             = local.workspace_default_region
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access     = "true"
    }
  ]
  secondary_ranges = var.workspace_vpc_secondary_ranges
  routes           = var.workspace_vpc_routes
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE FIREWALL
#----------------------------------------------------------------------------------------------

module "workspace_vpc_firewall" {
  source = "../../../modules/firewall"

  custom_rules = var.workspace_firewall_custom_rules
  network      = module.workspace_vpc.network_name
  project_id   = module.workspace_project.project_id
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE RESTRICTED GOOGLE API CLOUD DNS MODULE
#----------------------------------------------------------------------------------------------

module "researcher_workspace_restricted_api_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = var.workspace_restricted_api_cloud_dns_domain
  cloud_dns_name       = var.workspace_restricted_api_cloud_dns_name
  cloud_dns_project_id = module.workspace_project.project_id

  // OPTIONAL
  default_key_specs_key              = var.workspace_restricted_api_default_key_specs_key
  default_key_specs_zone             = var.workspace_restricted_api_default_key_specs_zone
  cloud_dns_description              = var.workspace_restricted_api_cloud_dns_description
  dnssec_config                      = var.workspace_restricted_api_dnssec_config
  cloud_dns_labels                   = var.workspace_restricted_api_cloud_dns_labels
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_restricted_api_cloud_dns_recordsets
  target_name_server_addresses       = var.workspace_restricted_api_target_name_server_addresses
  cloud_dns_target_network           = var.workspace_restricted_api_cloud_dns_target_network
  cloud_dns_zone_type                = var.workspace_restricted_api_cloud_dns_zone_type
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE IAP TUNNEL CLOUD DNS ZONE MODULE
# THIS PRIVATE ZONE FOR IAP IS NEEDED TO ESTABLISH IAP TUNNEL CONNECTIVITY FROM WITHIN A GCP VM TO ANOTHER GCP VM
# https://cloud.google.com/iap/docs/securing-tcp-with-vpc-sc#configure-dns
#----------------------------------------------------------------------------------------------

module "researcher_workspace_iap_tunnel_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = var.workspace_iap_tunnel_cloud_dns_domain
  cloud_dns_name       = var.workspace_iap_tunnel_cloud_dns_name
  cloud_dns_project_id = module.workspace_project.project_id

  // OPTIONAL
  default_key_specs_key              = var.workspace_iap_tunnel_default_key_specs_key
  default_key_specs_zone             = var.workspace_iap_tunnel_default_key_specs_zone
  cloud_dns_description              = var.workspace_iap_tunnel_cloud_dns_description
  dnssec_config                      = var.workspace_iap_tunnel_dnssec_config
  cloud_dns_labels                   = var.workspace_iap_tunnel_cloud_dns_labels
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_iap_tunnel_cloud_dns_recordsets
  target_name_server_addresses       = var.workspace_iap_tunnel_target_name_server_addresses
  cloud_dns_target_network           = var.workspace_iap_tunnel_cloud_dns_target_network
  cloud_dns_zone_type                = var.workspace_iap_tunnel_cloud_dns_zone_type
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE ARTIFACT REGISTRY CLOUD DNS ZONE MODULE
# THIS PRIVATE ZONE IS USED TO ACCESS THE ARTIFACT REGISTRY
#----------------------------------------------------------------------------------------------

module "researcher_workspace_artifact_registry_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = var.workspace_artifact_registry_cloud_dns_domain
  cloud_dns_name       = var.workspace_artifact_registry_cloud_dns_name
  cloud_dns_project_id = module.workspace_project.project_id

  // OPTIONAL
  default_key_specs_key              = var.workspace_artifact_registry_default_key_specs_key
  default_key_specs_zone             = var.workspace_artifact_registry_default_key_specs_zone
  cloud_dns_description              = var.workspace_artifact_registry_cloud_dns_description
  dnssec_config                      = var.workspace_artifact_registry_dnssec_config
  cloud_dns_labels                   = var.workspace_artifact_registry_cloud_dns_labels
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_artifact_registry_cloud_dns_recordsets
  target_name_server_addresses       = var.workspace_artifact_registry_target_name_server_addresses
  cloud_dns_target_network           = var.workspace_artifact_registry_cloud_dns_target_network
  cloud_dns_zone_type                = var.workspace_artifact_registry_cloud_dns_zone_type
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE DEEPLEARNING VM - PRIVATE IP MODULE
#----------------------------------------------------------------------------------------------

module "researcher_workspace_deeplearning_vm_private_ip" {
  count  = var.num_instances_deeplearing_vms
  source = "../../../modules/compute_vm_instance/private_ip_instance"

  // REQUIRED FIELDS
  project_id = module.workspace_project.project_id

  // OPTIONAL FIELDS
  allow_stopping_for_update = var.workspace_deeplearning_vm_allow_stopping_for_update
  vm_description            = var.workspace_deeplearning_vm_description
  desired_status            = var.workspace_deeplearning_vm_desired_status
  deletion_protection       = var.workspace_deeplearning_vm_deletion_protection
  labels                    = var.workspace_deeplearning_vm_labels
  metadata                  = var.workspace_deeplearning_vm_metadata
  machine_type              = var.workspace_deeplearning_vm_machine_type
  vm_name                   = "${local.researcher_workspace_name}-${var.workspace_deeplearning_vm_name}-${count.index}"
  tags                      = var.workspace_deeplearning_vm_tags
  zone                      = "${local.workspace_default_region}-b"

  // BOOT DISK

  initialize_params = [
    {
      vm_disk_size  = 100
      vm_disk_type  = "pd-standard"
      vm_disk_image = "${module.constants.value.packer_project_id}/${module.constants.value.packer_base_image_id_deeplearning}"
    }
  ]
  auto_delete_disk = var.workspace_deeplearning_vm_auto_delete_disk

  // NETWORK INTERFACE

  subnetwork = module.workspace_vpc.subnets_self_links[0]
  network_ip = var.workspace_deeplearning_vm_network_ip // KEEP AS AN EMPTY STRING FOR AN AUTOMATICALLY ASSIGNED PRIVATE IP

  // SERVICE ACCOUNT

  service_account_email  = module.workspace_deeplearning_vm_service_account.email
  service_account_scopes = var.workspace_deeplearning_vm_service_account_scopes

  // SHIELDED INSTANCE CONFIG

  enable_secure_boot          = var.workspace_deeplearning_vm_enable_secure_boot
  enable_vtpm                 = var.workspace_deeplearning_vm_enable_vtpm
  enable_integrity_monitoring = var.workspace_deeplearning_vm_enable_integrity_monitoring
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE - REGIONAL EXTERNAL STATIC IP MODULE
#----------------------------------------------------------------------------------------------

// FUNCTIONALITY IN THIS MODULE IS ONLY FOR A REGIONAL EXTERNAL STATIC IP

module "researcher_workspace_regional_external_static_ip" {
  source = "../../../modules/regional_external_static_ip"

  // REQUIRED
  regional_external_static_ip_name = format("%s-%s", local.researcher_workspace_name, "workspace-external-ip-nat")

  // OPTIONAL
  regional_external_static_ip_project_id   = module.workspace_project.project_id
  regional_external_static_ip_address_type = var.researcher_workspace_regional_external_static_ip_address_type
  regional_external_static_ip_description  = var.researcher_workspace_regional_external_static_ip_description
  regional_external_static_ip_network_tier = var.researcher_workspace_regional_external_static_ip_network_tier
  regional_external_static_ip_region       = local.workspace_default_region
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE - CLOUD NAT
#----------------------------------------------------------------------------------------------

module "researcher_workspace_cloud_nat" {
  source = "../../../modules/cloud_nat"

  create_router     = var.researcher_workspace_create_router
  project_id        = module.workspace_project.project_id
  cloud_nat_name    = format("%s-%s", local.researcher_workspace_name, "workspace-cloud-nat")
  cloud_nat_network = module.workspace_vpc.network_name
  region            = local.workspace_default_region
  router_name       = format("%s-%s", local.researcher_workspace_name, "workspace-clout-router")
  router_asn        = var.researcher_workspace_router_asn
  cloud_nat_subnetworks = [
    {
      name                     = module.workspace_vpc.subnets_names[0],
      source_ip_ranges_to_nat  = ["PRIMARY_IP_RANGE"],
      secondary_ip_range_names = []
    }
  ]
  enable_endpoint_independent_mapping = var.researcher_workspace_enable_endpoint_independent_mapping
  icmp_idle_timeout_sec               = var.researcher_workspace_icmp_idle_timeout_sec
  log_config_enable                   = var.researcher_workspace_log_config_enable
  log_config_filter                   = var.researcher_workspace_log_config_filter
  min_ports_per_vm                    = var.researcher_workspace_min_ports_per_vm
  nat_ip_allocate_option              = var.researcher_workspace_nat_ip_allocate_option
  nat_ips                             = [module.researcher_workspace_regional_external_static_ip.regional_external_static_ip_self_link]
  source_subnetwork_ip_ranges_to_nat  = var.researcher_workspace_source_subnetwork_ip_ranges_to_nat
  tcp_established_idle_timeout_sec    = var.researcher_workspace_tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.researcher_workspace_tcp_transitory_idle_timeout_sec
  udp_idle_timeout_sec                = var.researcher_workspace_udp_idle_timeout_sec
}

#----------------------------------------------------------------------------------------------
# BASTION - PROJECT
#----------------------------------------------------------------------------------------------

module "researcher-bastion-access-project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = format("%v-%v", local.researcher_workspace_name, "bastion")
  org_id             = local.org_id
  billing_account_id = local.billing_account_id
  folder_id          = local.srde_folder_id

  // OPTIONAL FIELDS
  activate_apis = [
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "oslogin.googleapis.com",
    "iap.googleapis.com",
    "osconfig.googleapis.com"
  ]
  auto_create_network         = false
  random_project_id           = true
  lien                        = false
  create_project_sa           = false
  default_service_account     = var.bastion_project_default_service_account
  disable_dependent_services  = true
  disable_services_on_destroy = true
  project_labels = {
    "researcher-workspace" = "${local.researcher_workspace_name}-bastion-project"
  }
}

resource "google_compute_project_metadata" "researcher_bastion_project" {
  project = module.researcher-bastion-access-project.project_id
  metadata = {
    enable-osconfig = "TRUE",
    enable-oslogin  = "TRUE"
  }
}

#----------------------------------------------------------------------------------------------
# BASTION PROJECT IAM MEMBER BINDING
# BIND IAM MEMBERS & ROLES AT THE PROJECT LEVEL CAN BE DONE WITH GROUPS HERE
# USE SYNTAX `group:<GOOGLE_GROUP_NAME>`
#----------------------------------------------------------------------------------------------

module "bastion_project_iam_member" {
  source = "../../../modules/iam/project_iam"

  project_id            = module.researcher-bastion-access-project.project_id
  project_member        = var.bastion_project_member
  project_iam_role_list = var.bastion_project_iam_role_list
}

#----------------------------------------------------------------------------------------------
# RESEARCHER BASTION PROJECT IAM CUSTOM ROLE MODULE
#----------------------------------------------------------------------------------------------

module "bastion_project_iam_custom_role" {
  source = "../../../modules/iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.researcher-bastion-access-project.project_id
  project_iam_custom_role_description = var.bastion_project_iam_custom_role_description
  project_iam_custom_role_id          = var.bastion_project_iam_custom_role_id
  project_iam_custom_role_title       = var.bastion_project_iam_custom_role_title
  project_iam_custom_role_permissions = var.bastion_project_iam_custom_role_permissions
  project_iam_custom_role_stage       = var.bastion_project_iam_custom_role_stage
}

#----------------------------------------------------------------------------------------------
# RESEARCHER BASTION PROJECT IAM MEMBER CUSTOM SRDE ROLE
# USED SPECIFICALLY TO BIND CUSTOM IAM ROLE IN BASTION PROJECT TO RESEARCH USER OR GROUP
#----------------------------------------------------------------------------------------------

resource "google_project_iam_member" "researcher_bastion_project_custom_srde_role" {

  project = module.researcher-bastion-access-project.project_id
  role    = module.bastion_project_iam_custom_role.name
  member  = var.bastion_project_member // CURRENTLY SET TO USERS/GROUPS DEFINED IN TFVARS
}

#----------------------------------------------------------------------------------------------
# BASTION PROJECT - VM SERVICE ACCOUNT
#----------------------------------------------------------------------------------------------

module "bastion_project_service_account" {
  source = "../../../modules/service_account"

  project_id            = module.researcher-bastion-access-project.project_id
  billing_account_id    = local.billing_account_id
  description           = "Researcher Bastion Project VM Service Account"
  display_name          = "Terraform-managed service account"
  service_account_names = var.bastion_project_sa_service_account_names
  org_id                = local.org_id
}

#----------------------------------------------------------------------------------------------
# BASTION VM SERVICE ACCOUNT - PROJECT IAM MEMBER MODULE
#----------------------------------------------------------------------------------------------

module "bastion_vm_sa_project_iam_member" {
  source = "../../../modules/iam/project_iam"

  project_id            = module.researcher-bastion-access-project.project_id
  project_member        = module.bastion_project_service_account.iam_email
  project_iam_role_list = var.bastion_vm_sa_project_iam_role_list
}

#----------------------------------------------------------------------------------------------
# BASTION PROJECT - VPC
#----------------------------------------------------------------------------------------------

module "bastion_project_vpc" {
  source = "../../../modules/vpc"

  project_id                             = module.researcher-bastion-access-project.project_id
  vpc_network_name                       = format("%s-%s", local.researcher_workspace_name, "bastion-vpc")
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = var.bastion_project_vpc_delete_default_internet_gateway_routes
  routing_mode                           = var.bastion_project_vpc_routing_mode
  vpc_description                        = var.bastion_project_vpc_description
  shared_vpc_host                        = false
  mtu                                    = var.bastion_project_vpc_mtu
  subnets = [
    {
      subnet_name               = "${local.researcher_workspace_name}-${local.bastion_default_region}-bastion-subnet"
      subnet_ip                 = "10.10.0.0/16"
      subnet_region             = local.bastion_default_region
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access     = "true"
    }
  ]
  secondary_ranges = var.bastion_project_vpc_secondary_ranges
  routes           = var.bastion_project_vpc_routes
}

#----------------------------------------------------------------------------------------------
# BASTION PROJECT - FIREWALL
#----------------------------------------------------------------------------------------------

module "researcher_bastion_project_vpc_firewall" {
  source = "../../../modules/firewall"

  custom_rules = var.bastion_project_firewall_custom_rules
  network      = module.bastion_project_vpc.network_name
  project_id   = module.researcher-bastion-access-project.project_id
}

#----------------------------------------------------------------------------------------------
# RESEARCHER BASTION VM - PRIVATE IP MODULE
# VALUE SET IN `TAGS` FIELD BELOW IS USED IN IAP MODULE FOR FIREWALL FILTERING
#----------------------------------------------------------------------------------------------

module "researcher_bastion_vm_private_ip" {
  count  = var.num_instances_researcher_bastion_vms
  source = "../../../modules/compute_vm_instance/private_ip_instance"

  // REQUIRED FIELDS
  project_id = module.researcher-bastion-access-project.project_id

  // OPTIONAL FIELDS
  allow_stopping_for_update = var.bastion_vm_allow_stopping_for_update
  vm_description            = var.bastion_vm_description
  desired_status            = var.bastion_vm_desired_status
  deletion_protection       = var.bastion_vm_deletion_protection
  labels                    = var.bastion_vm_labels
  metadata                  = var.bastion_vm_metadata
  metadata_startup_script   = file("./sde-bastion-vm.sh")
  machine_type              = var.bastion_vm_machine_type
  vm_name                   = "${local.researcher_workspace_name}-${var.bastion_vm_name}-${count.index}"
  tags                      = var.bastion_vm_tags
  zone                      = "${local.bastion_default_region}-b"

  // BOOT DISK

  initialize_params = [
    {
      vm_disk_size  = 100
      vm_disk_type  = "pd-standard"
      vm_disk_image = "${module.constants.value.packer_project_id}/${module.constants.value.packer_base_image_id_bastion}"
    }
  ]
  auto_delete_disk = var.bastion_vm_auto_delete_disk

  // NETWORK INTERFACE

  subnetwork = module.bastion_project_vpc.subnets_self_links[0]
  network_ip = var.bastion_vm_network_ip // KEEP AS AN EMPTY STRING FOR AN AUTOMATICALLY ASSIGNED PRIVATE IP

  // SERVICE ACCOUNT

  service_account_email  = module.bastion_project_service_account.email
  service_account_scopes = var.bastion_vm_service_account_scopes

  // SHIELDED INSTANCE CONFIG

  enable_secure_boot          = var.bastion_vm_enable_secure_boot
  enable_vtpm                 = var.bastion_vm_enable_vtpm
  enable_integrity_monitoring = var.bastion_vm_enable_integrity_monitoring
}

#----------------------------------------------------------------------------------------------
# BASTION PROJECT - REGIONAL EXTERNAL STATIC IP MODULE
# FUNCTIONALITY IN THIS MODULE IS ONLY FOR A REGIONAL EXTERNAL STATIC IP
#----------------------------------------------------------------------------------------------

module "bastion_project_regional_external_static_ip" {
  source = "../../../modules/regional_external_static_ip"

  // REQUIRED
  regional_external_static_ip_name = "${local.researcher_workspace_name}-basion-external-ip-nat"

  // OPTIONAL
  regional_external_static_ip_project_id   = module.researcher-bastion-access-project.project_id
  regional_external_static_ip_address_type = var.bastion_project_regional_external_static_ip_address_type
  regional_external_static_ip_description  = var.bastion_project_regional_external_static_ip_description
  regional_external_static_ip_network_tier = var.bastion_project_regional_external_static_ip_network_tier
  regional_external_static_ip_region       = local.bastion_default_region
}

#----------------------------------------------------------------------------------------------
# BASTION PROJECT - CLOUD NAT
#----------------------------------------------------------------------------------------------

module "bastion_project_cloud_nat" {
  source = "../../../modules/cloud_nat"

  create_router     = true
  project_id        = module.researcher-bastion-access-project.project_id
  cloud_nat_name    = "${local.researcher_workspace_name}-bastion-cloud-nat"
  cloud_nat_network = module.bastion_project_vpc.network_name
  region            = local.bastion_default_region
  router_name       = "${local.researcher_workspace_name}-bastion-cloud-router"
  router_asn        = var.bastion_project_router_asn
  cloud_nat_subnetworks = [
    {
      name                     = module.bastion_project_vpc.subnets_names[0],
      source_ip_ranges_to_nat  = ["PRIMARY_IP_RANGE"],
      secondary_ip_range_names = []
    }
  ]
  enable_endpoint_independent_mapping = var.bastion_project_enable_endpoint_independent_mapping
  icmp_idle_timeout_sec               = var.bastion_project_icmp_idle_timeout_sec
  log_config_enable                   = var.bastion_project_log_config_enable
  log_config_filter                   = var.bastion_project_log_config_filter
  min_ports_per_vm                    = var.bastion_project_min_ports_per_vm
  nat_ip_allocate_option              = var.bastion_project_nat_ip_allocate_option
  nat_ips                             = [module.bastion_project_regional_external_static_ip.regional_external_static_ip_self_link]
  source_subnetwork_ip_ranges_to_nat  = var.bastion_project_source_subnetwork_ip_ranges_to_nat
  tcp_established_idle_timeout_sec    = var.bastion_project_tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.bastion_project_tcp_transitory_idle_timeout_sec
  udp_idle_timeout_sec                = var.bastion_project_udp_idle_timeout_sec
}

#----------------------------------------------------------------------------------------------
# DATA EGRESS - PROJECT
#----------------------------------------------------------------------------------------------

module "researcher-data-egress-project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = format("%v-%v", local.researcher_workspace_name, "data-egress")
  org_id             = local.org_id
  billing_account_id = local.billing_account_id
  folder_id          = local.srde_folder_id

  // OPTIONAL FIELDS
  activate_apis               = ["storage.googleapis.com"]
  auto_create_network         = false
  create_project_sa           = false
  lien                        = false
  random_project_id           = true
  default_service_account     = var.egress_default_service_account
  disable_dependent_services  = true
  disable_services_on_destroy = true
  project_labels = {
    "researcher-workspace" : "${local.researcher_workspace_name}-egress-project"
  }
}

resource "google_compute_project_metadata" "researcher_egress_project" {
  project = module.researcher-data-egress-project.project_id
  metadata = {
    enable-osconfig = "TRUE",
    enable-oslogin  = "TRUE"
  }
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE TO RESEARCHER BASTION VPC PEERING
#----------------------------------------------------------------------------------------------

module "researcher_workspace_to_bastion_vpc_peer" {
  source = "../../../modules/vpc_peering"

  vpc_peering_name                    = "${local.researcher_workspace_name}-workspace-project-to-bastion-project"
  vpc_network_name                    = module.workspace_vpc.network_self_link
  peer_network_name                   = module.bastion_project_vpc.network_self_link
  export_custom_routes                = var.researcher_workspace_to_bastion_export_custom_routes
  import_custom_routes                = var.researcher_workspace_to_bastion_import_custom_routes
  export_subnet_routes_with_public_ip = var.researcher_workspace_to_bastion_export_subnet_routes_with_public_ip
  import_subnet_routes_with_public_ip = var.researcher_workspace_to_bastion_import_subnet_routes_with_public_ip
}

#----------------------------------------------------------------------------------------------
# RESEARCHER BASTION TO WORKSAPCE VPC PEERING
#----------------------------------------------------------------------------------------------

module "researcher_bastion_to_workspace_vpc_peer" {
  source = "../../../modules/vpc_peering"

  vpc_peering_name                    = "${local.researcher_workspace_name}-bastion-project-to-workspace-project"
  vpc_network_name                    = module.bastion_project_vpc.network_self_link
  peer_network_name                   = module.workspace_vpc.network_self_link
  export_custom_routes                = var.researcher_bastion_to_workspace_export_custom_routes
  import_custom_routes                = var.researcher_bastion_to_workspace_import_custom_routes
  export_subnet_routes_with_public_ip = var.researcher_bastion_to_workspace_export_subnet_routes_with_public_ip
  import_subnet_routes_with_public_ip = var.researcher_bastion_to_workspace_import_subnet_routes_with_public_ip
}