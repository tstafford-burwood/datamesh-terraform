# ---------------------------------------------------------------------------
# REQUIRED VARIABLE
# ---------------------------------------------------------------------------

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "terraform_foundation_state_prefix" {
  description = "The name of the foundation prefix to create in the state bucket. Set in during the pipeline."
  type        = string
  default     = ""
}


variable "researcher_workspace_name" {
  description = "The research workspace name. This will be descriptor for all projects and resources."
  type        = string
}

variable "workspace_default_region" {
  description = "The default region to place resources."
  type        = string
  default     = "us-central1"
}


#-----------------------------------------
# RESEARCHER WORKSPACE - PROJECT VARIABLES
#-----------------------------------------

variable "workspace_default_service_account" {
  description = "Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
  type        = string
  default     = "delete"
}

#----------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM MEMBER BINDING VARIABLES
#----------------------------------------------------------

variable "workspace_project_member" {
  description = "The member to apply the IAM role to. Possible options use the following syntax: user:{emailid}, serviceAccount:{emailid}, group:{emailid}, domain:{domain}."
  type        = string
  default     = ""
}

variable "workspace_project_iam_role_list" {
  description = "The IAM role(s) to assign to the member at the defined project."
  type        = list(string)
  default     = []
}

#-------------------------------------
# RESEARCHER WORKSPACE - VPC VARIABLES
#-------------------------------------

variable "workspace_vpc_delete_default_internet_gateway_routes" {
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  type        = bool
  default     = false
}

variable "workspace_vpc_firewall_rules" {
  description = "List of firewall rules"
  type        = any
  default     = []
}

variable "workspace_vpc_routing_mode" {
  description = "The network routing mode for regional dynamic routing or global dynamic routing (default 'GLOBAL' otherwise use 'REGIONAL')"
  type        = string
  default     = "GLOBAL"
}

variable "workspace_vpc_description" {
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  type        = string
  default     = "VPC created from Terraform for web app use case deployment."
}

variable "workspace_vpc_shared_vpc_host" {
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
  type        = bool
  default     = false
}

variable "workspace_vpc_mtu" {
  type        = number
  description = "The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically."
  default     = 1460
}

variable "workspace_vpc_subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default     = []
}

variable "workspace_vpc_secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "workspace_vpc_routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC. For more information see [link](https://github.com/terraform-google-modules/terraform-google-network#route-inputs)"
  default     = []
}

#--------------------------------------------------------
# RESEARCHER WORKSPACE RESTRICTED API CLOUD DNS VARIABLES
#--------------------------------------------------------

// REQUIRED VARIABLES


variable "workspace_restricted_api_cloud_dns_project_id" {
  description = "Project id for the zone."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "workspace_restricted_api_cloud_dns_recordsets" {
  description = "List of DNS record objects to manage, in the standard Terraform DNS structure."
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

#----------------------------------------------------
# RESEARCHER WORKSPACE IAP TUNNEL CLOUD DNS VARIABLES
#----------------------------------------------------

// REQUIRED VARIABLES

variable "workspace_iap_tunnel_cloud_dns_project_id" {
  description = "Project id for the zone."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "workspace_iap_tunnel_cloud_dns_recordsets" {
  description = "List of DNS record objects to manage, in the standard Terraform DNS structure."
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

#-----------------------------------------------------------
# RESEARCHER WORKSPACE ARTIFACT REGISTRY CLOUD DNS VARIABLES
#-----------------------------------------------------------

// REQUIRED VARIABLES

variable "workspace_artifact_registry_cloud_dns_project_id" {
  description = "Project id for the zone."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES


variable "activate_apis" {
  description = "List of APIs to enable in project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "oslogin.googleapis.com",
    "iap.googleapis.com",
    "bigquery.googleapis.com",
    "dns.googleapis.com",
    "notebooks.googleapis.com",
    "osconfig.googleapis.com",
    "monitoring.googleapis.com"
  ]
}

variable "workspace_artifact_registry_cloud_dns_recordsets" {
  description = "List of DNS record objects to manage, in the standard Terraform DNS structure."
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "workspace_notebooks_google_cloud_dns_recordsets" {
  description = "List of DNS record objects to manage, in the standard Terraform DNS structure."
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "workspace_notebooks_googleusercontent_dns_recordsets" {
  description = "List of DNS record objects to manage, in the standard Terraform DNS structure."
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "workspace_artifact_registry_target_name_server_addresses" {
  description = "List of target name servers for forwarding zone."
  type        = list(string)
  default     = []
}

#--------------------------------------------
# RESEARCHER WORKSPACE VPC FIREWALL VARIABLES
#--------------------------------------------

variable "workspace_firewall_custom_rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  default     = {}
  type = map(object({
    description          = string
    direction            = string
    action               = string # (allow|deny)
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    use_service_accounts = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
    extra_attributes   = map(string)
    flow_logs_metadata = string
  }))
}

#-------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM CUSTOM ROLE VARIABLES
#-------------------------------------------------------

variable "workspace_project_iam_custom_role_project_id" {
  description = "The project that the custom role will be created in. Defaults to the provider project configuration."
  type        = string
  default     = ""
}

variable "workspace_project_iam_custom_role_description" {
  description = "A human-readable description for the role."
  type        = string
  default     = "Custom role created with Terraform."
}

variable "workspace_project_iam_custom_role_id" {
  description = "The camel case role id to use for this role. Cannot contain - characters."
  type        = string
  default     = ""
}

variable "workspace_project_iam_custom_role_title" {
  description = "A human-readable title for the role."
  type        = string
  default     = ""
}

variable "workspace_project_iam_custom_role_permissions" {
  description = "The names of the permissions this role grants when bound in an IAM policy. At least one permission must be specified."
  type        = list(string)
  default     = []
}

variable "workspace_project_iam_custom_role_stage" {
  description = "The current launch stage of the role. Defaults to GA. List of possible stages is [here](https://cloud.google.com/iam/docs/reference/rest/v1/organizations.roles#Role.RoleLaunchStage)."
  type        = string
  default     = "GA"
}

#-------------------------------------------------------------
# RESEARCHER WORKSPACE - REGIONAL EXTERNAL STATIC IP VARIABLES
#-------------------------------------------------------------

# variable "researcher_workspace_regional_external_static_ip_name" {
#   description = "The name must be 1-63 characters long and match the regular expression `[a-z]([-a-z0-9]*[a-z0-9])?` which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
#   type        = string
#   default     = ""
# }

variable "researcher_workspace_regional_external_static_ip_project_id" {
  description = "The project ID to provision this resource into."
  type        = string
  default     = ""
}

variable "researcher_workspace_regional_external_static_ip_address_type" {
  description = "The type of address to reserve. Default value is EXTERNAL. Possible values are INTERNAL and EXTERNAL."
  type        = string
  default     = "EXTERNAL"
}

variable "researcher_workspace_regional_external_static_ip_description" {
  description = "The description to attach to the IP address."
  type        = string
  default     = "Created with Terraform"
}

variable "researcher_workspace_regional_external_static_ip_network_tier" {
  description = "The networking tier used for configuring this address. If this field is not specified, it is assumed to be PREMIUM. Possible values are PREMIUM and STANDARD."
  type        = string
  default     = "PREMIUM"
}

variable "researcher_workspace_regional_external_static_ip_region" {
  description = "The Region in which the created address should reside. If it is not provided, the provider region is used."
  type        = string
  default     = ""
}

#-------------------------------------------
# RESEARCHER WORKSPACE - CLOUD NAT VARIABLES
#-------------------------------------------

variable "researcher_workspace_create_router" {
  description = "Create router instead of using an existing one, uses 'router' variable for new resource name."
  type        = bool
  default     = false
}

variable "researcher_workspace_cloud_nat_network" {
  description = "VPC name, only if router is not passed in and is created by the module."
  type        = string
  default     = ""
}

variable "researcher_workspace_region" {
  description = "The region to deploy to."
  type        = string
  default     = ""
}

variable "researcher_workspace_router_asn" {
  description = "Router ASN, only if router is not passed in and is created by the module."
  type        = string
  default     = "64514"
}

variable "researcher_workspace_cloud_nat_subnetworks" {
  description = "The subnetwork to use Cloud NAT with."
  type = list(object({
    name                     = string,
    source_ip_ranges_to_nat  = list(string)
    secondary_ip_range_names = list(string)
  }))
  default = []
}

variable "researcher_workspace_enable_endpoint_independent_mapping" {
  description = "Specifies if endpoint independent mapping is enabled."
  type        = bool
  default     = null
}

variable "researcher_workspace_icmp_idle_timeout_sec" {
  description = "Timeout (in seconds) for ICMP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "30"
}

variable "researcher_workspace_log_config_enable" {
  description = "Indicates whether or not to export logs"
  type        = bool
  default     = false
}

variable "researcher_workspace_log_config_filter" {
  description = "Specifies the desired filtering of logs on this NAT. Valid values are: \"ERRORS_ONLY\", \"TRANSLATIONS_ONLY\", \"ALL\""
  type        = string
  default     = "ALL"
}

variable "researcher_workspace_min_ports_per_vm" {
  description = "Minimum number of ports allocated to a VM from this NAT config. Defaults to 64 if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "64"
}

variable "researcher_workspace_nat_ip_allocate_option" {
  description = "Value inferred based on nat_ips. If present set to MANUAL_ONLY, otherwise AUTO_ONLY."
  type        = string
  default     = "false"
}

variable "researcher_workspace_nat_ips" {
  description = "List of self_links of external IPs. Changing this forces a new NAT to be created."
  type        = list(string)
  default     = []
}

variable "researcher_workspace_source_subnetwork_ip_ranges_to_nat" {
  description = "Defaults to ALL_SUBNETWORKS_ALL_IP_RANGES. How NAT should be configured per Subnetwork. Valid values include: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS. Changing this forces a new NAT to be created."
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "researcher_workspace_tcp_established_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "1200"
}

variable "researcher_workspace_tcp_transitory_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "30"
}

variable "researcher_workspace_udp_idle_timeout_sec" {
  description = "Timeout (in seconds) for UDP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "30"
}



#--------------
# IAP VARIABLES
#--------------

// REQUIRED

variable "instances" {
  description = "Names and zones of the instances to allow SSH from IAP."
  type = list(object({
    name = string
    zone = string
  }))
  default = []
}

variable "iap_members" {
  description = "List of IAM resources to allow using the IAP tunnel."
  type        = list(string)
  default     = []
}

// OPTIONAL

variable "additional_ports" {
  description = "A list of additional ports/ranges to open access to on the instances from IAP."
  type        = list(string)
  default     = []
}

variable "create_firewall_rule" {
  description = "If we need to create the firewall rule or not."
  type        = bool
  default     = true
}

variable "fw_name_allow_ssh_from_iap" {
  description = "Firewall rule name for allowing SSH from IAP."
  type        = string
  default     = "allow-ssh-from-iap-to-tunnel"
}

variable "host_project" {
  description = "The network host project ID."
  default     = ""
}

variable "network_tags" {
  description = "Network tags associated with the instances to allow SSH from IAP. Exactly one of service_accounts or network_tags should be specified."
  type        = list(string)
  default     = []
}

#-----------------------------------------
# RESEARCHER DATA EGRESS PROJECT VARIABLES
#-----------------------------------------

variable "egress_default_service_account" {
  description = "Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
  type        = string
  default     = "delete"
}

#----------------------------------------------
# RESEARCHER WORKSPACE SERVICE ACCOUNT CREATION
#----------------------------------------------

variable "enforce_researcher_workspace_disable_sa_creation" {
  description = "Define variable to disable and enable policy at the project level during provisioning."
  type        = bool
  default     = true
}
