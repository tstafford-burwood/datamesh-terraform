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
# BASTION PROJECT IAM CUSTOM ROLE MODULE
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
# BASTION VM - PRIVATE IP MODULE
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
      vm_disk_image = "${local.imaging_project_id}/${module.constants.value.packer_base_image_id_bastion}"
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

#---------------------------------------------------------------
# BASTION VPC - RESTRICT VPC PEERING TO WORKSPACE VPC
# THE BELOW POLICIES ARE LISTED HERE TO DISABLE THEN RE-ENABLE DURING CLOUD BUILD PIPELINE RUNS
# THESE POLICIES ARE ALSO APPLIED AT THE SRDE FOLDER LEVEL IN THE `../srde-folder-policies` DIRECTORY
#---------------------------------------------------------------

module "researcher_bastion_vpc_restrict_vpc_peering_to_workspace_vpc" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  constraint        = "constraints/compute.restrictVpcPeering"
  policy_type       = "list"
  policy_for        = "project"
  project_id        = module.researcher-bastion-access-project.project_id
  enforce           = null
  allow             = ["projects/${module.workspace_project.project_id}/global/networks/${module.workspace_vpc.network_name}"]
  allow_list_length = 1
  depends_on        = [module.researcher_bastion_to_workspace_vpc_peer, module.researcher_workspace_to_bastion_vpc_peer]
}

#-----------------------------------------
# BASTION PROJECT SERVICE ACCOUNT CREATION
#-----------------------------------------

module "bastion_project_disable_sa_creation" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/iam.disableServiceAccountCreation"
  policy_type = "boolean"
  policy_for  = "project"
  project_id  = module.researcher-bastion-access-project.project_id
  enforce     = var.enforce_bastion_project_disable_sa_creation
}