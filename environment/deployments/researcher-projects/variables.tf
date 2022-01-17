# ---------------------------------------------------------------------------
# REQUIRED VARIABLE
# ---------------------------------------------------------------------------

variable "researcher_workspace_name" {
  description = "The research workspace name. This will be descripter for all projects and resources."
  type = string
}


#-----------------------------------------
# RESEARCHER WORKSPACE - PROJECT VARIABLES
#-----------------------------------------

variable "workspace_default_service_account" {
  description = "Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
  type        = string
  default     = "delete"
}

#-----------------------------------------
# GOOGLE CLOUD SOURCE REPOSITORY VARIABLES
#-----------------------------------------

variable "workspace_cloud_source_repo_name" {
  description = "Resource name of the repository, of the form {{repo}}. The repo name may contain slashes. eg, name/with/slash."
  type        = string
  default     = ""
}

variable "workspace_cloud_source_repo_project_id" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = ""
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

variable "workspace_restricted_api_cloud_dns_domain" {
  description = "Zone domain, must end with a period."
  type        = string
}

variable "workspace_restricted_api_cloud_dns_name" {
  description = "Zone name, must be unique within the project."
  type        = string
}

variable "workspace_restricted_api_cloud_dns_project_id" {
  description = "Project id for the zone."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "workspace_restricted_api_default_key_specs_key" {
  description = "Object containing default key signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "workspace_restricted_api_default_key_specs_zone" {
  description = "Object containing default zone signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "workspace_restricted_api_cloud_dns_description" {
  description = "zone description (shown in console)"
  type        = string
  default     = "Managed by Terraform"
}

variable "workspace_restricted_api_dnssec_config" {
  description = "Object containing : kind, non_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "workspace_restricted_api_cloud_dns_labels" {
  description = "A set of key/value label pairs to assign to this ManagedZone"
  type        = map(any)
  default     = {}
}

variable "workspace_restricted_api_private_visibility_config_networks" {
  description = "List of VPC self links that can see this zone."
  type        = list(string)
  default     = []
}

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

variable "workspace_restricted_api_target_name_server_addresses" {
  description = "List of target name servers for forwarding zone."
  type        = list(string)
  default     = []
}

variable "workspace_restricted_api_cloud_dns_target_network" {
  description = "Peering network."
  type        = string
  default     = ""
}

variable "workspace_restricted_api_cloud_dns_zone_type" {
  description = "Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering'."
  type        = string
  default     = "private"
}

#----------------------------------------------------
# RESEARCHER WORKSPACE IAP TUNNEL CLOUD DNS VARIABLES
#----------------------------------------------------

// REQUIRED VARIABLES

variable "workspace_iap_tunnel_cloud_dns_domain" {
  description = "Zone domain, must end with a period."
  type        = string
}

variable "workspace_iap_tunnel_cloud_dns_name" {
  description = "Zone name, must be unique within the project."
  type        = string
}

variable "workspace_iap_tunnel_cloud_dns_project_id" {
  description = "Project id for the zone."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "workspace_iap_tunnel_default_key_specs_key" {
  description = "Object containing default key signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "workspace_iap_tunnel_default_key_specs_zone" {
  description = "Object containing default zone signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "workspace_iap_tunnel_cloud_dns_description" {
  description = "zone description (shown in console)"
  type        = string
  default     = "Managed by Terraform"
}

variable "workspace_iap_tunnel_dnssec_config" {
  description = "Object containing : kind, non_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "workspace_iap_tunnel_cloud_dns_labels" {
  description = "A set of key/value label pairs to assign to this ManagedZone"
  type        = map(any)
  default     = {}
}

variable "workspace_iap_tunnel_private_visibility_config_networks" {
  description = "List of VPC self links that can see this zone."
  type        = list(string)
  default     = []
}

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

variable "workspace_iap_tunnel_target_name_server_addresses" {
  description = "List of target name servers for forwarding zone."
  type        = list(string)
  default     = []
}

variable "workspace_iap_tunnel_cloud_dns_target_network" {
  description = "Peering network."
  type        = string
  default     = ""
}

variable "workspace_iap_tunnel_cloud_dns_zone_type" {
  description = "Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering'."
  type        = string
  default     = "private"
}

#-----------------------------------------------------------
# RESEARCHER WORKSPACE ARTIFACT REGISTRY CLOUD DNS VARIABLES
#-----------------------------------------------------------

// REQUIRED VARIABLES

variable "workspace_artifact_registry_cloud_dns_domain" {
  description = "Zone domain, must end with a period."
  type        = string
}

variable "workspace_artifact_registry_cloud_dns_name" {
  description = "Zone name, must be unique within the project."
  type        = string
}

variable "workspace_artifact_registry_cloud_dns_project_id" {
  description = "Project id for the zone."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "workspace_artifact_registry_default_key_specs_key" {
  description = "Object containing default key signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "workspace_artifact_registry_default_key_specs_zone" {
  description = "Object containing default zone signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "workspace_artifact_registry_cloud_dns_description" {
  description = "zone description (shown in console)"
  type        = string
  default     = "Managed by Terraform"
}

variable "workspace_artifact_registry_dnssec_config" {
  description = "Object containing : kind, non_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "workspace_artifact_registry_cloud_dns_labels" {
  description = "A set of key/value label pairs to assign to this ManagedZone"
  type        = map(any)
  default     = {}
}

variable "workspace_artifact_registry_private_visibility_config_networks" {
  description = "List of VPC self links that can see this zone."
  type        = list(string)
  default     = []
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

variable "workspace_artifact_registry_target_name_server_addresses" {
  description = "List of target name servers for forwarding zone."
  type        = list(string)
  default     = []
}

variable "workspace_artifact_registry_cloud_dns_target_network" {
  description = "Peering network."
  type        = string
  default     = ""
}

variable "workspace_artifact_registry_cloud_dns_zone_type" {
  description = "Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering'."
  type        = string
  default     = "private"
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

#------------------------------------------------------
# RESEARCHER WORKSPACE TO BASTION VPC PEERING VARIABLES
#------------------------------------------------------

variable "researcher_workspace_to_bastion_export_custom_routes" {
  description = "Whether to export the custom routes to the peer network. Defaults to false."
  type        = bool
  default     = true
}

variable "researcher_workspace_to_bastion_import_custom_routes" {
  description = "Whether to import the custom routes from the peer network. Defaults to false."
  type        = bool
  default     = true
}

variable "researcher_workspace_to_bastion_export_subnet_routes_with_public_ip" {
  description = "Whether subnet routes with public IP range are exported. The default value is false, all subnet routes are exported. The IPv4 special-use ranges (https://en.wikipedia.org/wiki/IPv4#Special_addresses) are always exported to peers and are not controlled by this field."
  type        = bool
  default     = true
}

variable "researcher_workspace_to_bastion_import_subnet_routes_with_public_ip" {
  description = "Whether subnet routes with public IP range are imported. The default value is false. The IPv4 special-use ranges (https://en.wikipedia.org/wiki/IPv4#Special_addresses) are always imported from peers and are not controlled by this field."
  type        = bool
  default     = true
}

#-----------------------------------------------------------------
# RESEARCHER WORKSPACE - DEEPLEARNING VM SERVICE ACCOUNT VARIABLES
#-----------------------------------------------------------------

// OPTIONAL VARIABLES

variable "workspace_deeplearning_vm_sa_description" {
  type        = string
  description = "Descriptions of the created service accounts (defaults to no description)"
  default     = ""
}

variable "workspace_deeplearning_vm_sa_display_name" {
  type        = string
  description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
  default     = "Terraform-managed service account"
}

variable "workspace_deeplearning_vm_sa_generate_keys" {
  description = "Generate keys for service accounts."
  type        = bool
  default     = false
}

variable "workspace_deeplearning_vm_sa_service_account_names" {
  description = "Names of the service accounts to create."
  type        = list(string)
  default     = [""]
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
  default     = ""
}

#-------------------------------------------------------------
# RESEARCHER WORKSPACE DEEP LEARNING VM - PRIVATE IP VARIABLES
#-------------------------------------------------------------

variable "num_instances_deeplearing_vms" {
  description = "Number of instances to create."
  type        = number
  default     = 0
}

variable "workspace_deeplearning_vm_allow_stopping_for_update" {
  description = "If true, allows Terraform to stop the instance to update its properties. If you try to update a property that requires stopping the instance without setting this field, the update will fail."
  type        = bool
  default     = true
}

variable "workspace_deeplearning_vm_description" {
  description = "A description of the VM instance."
  type        = string
  default     = "VM created with Terraform"
}

variable "workspace_deeplearning_vm_desired_status" {
  description = "Desired status of the instance. Either `RUNNING` or `TERMINATED`."
  type        = string
  default     = "RUNNING"
}

variable "workspace_deeplearning_vm_deletion_protection" {
  description = "Enable deletion protection on this instance. Defaults to false. You must disable deletion protection before the resource can be removed (e.g., via terraform destroy). Otherwise the instance cannot be deleted and the Terraform run will not complete successfully."
  type        = bool
  default     = false
}

variable "workspace_deeplearning_vm_labels" {
  description = "A map of key/value label pairs to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "workspace_deeplearning_vm_metadata" {
  description = "Metadata key/value pairs to make available from within the instance. SSH keys attached in the Cloud Console will be removed. Add them to your configuration in order to keep them attached to your instance."
  type        = map(string)
  default     = {}
}

variable "workspace_deeplearning_vm_machine_type" {
  description = "The machine type to create. For example `n2-standard-2`."
  type        = string
  default     = ""
}

variable "workspace_deeplearning_vm_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  type        = string
}

variable "workspace_deeplearning_vm_tags" {
  description = "A list of network tags to attach to the instance."
  type        = list(string)
  default     = []
}

// BOOT DISK BLOCK VARIABLES

variable "workspace_deeplearning_vm_auto_delete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted. Defaults to true."
  type        = bool
  default     = true
}

variable "workspace_deeplearning_vm_device_name" {
  description = "Name with which attached disk will be accessible. On the instance, this device will be `/dev/disk/by-id/google-{{device_name}}`."
  type        = string
  default     = ""
}

variable "workspace_deeplearning_vm_disk_mode" {
  description = "The mode in which to attach this disk, either READ_WRITE or READ_ONLY. If not specified, the default is to attach the disk in READ_WRITE mode."
  type        = string
  default     = "READ_WRITE"
}

variable "workspace_deeplearning_vm_kms_key_self_link" {
  description = "The self_link of the encryption key that is stored in Google Cloud KMS to encrypt this disk. Only one of kms_key_self_link and disk_encryption_key_raw may be set."
  type        = string
  default     = ""
}

variable "workspace_deeplearning_vm_source_disk" {
  description = "The name or self_link of the existing disk (such as those managed by google_compute_disk) or disk image. To create an instance from a snapshot, first create a google_compute_disk from a snapshot and reference it here."
  type        = string
  default     = ""
}

variable "workspace_deeplearning_vm_disk_size" {
  description = "Placeholder variable to define initialize_params input. The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  type        = number
  default     = null
}

variable "workspace_deeplearning_vm_disk_type" {
  description = "Placeholder variable to define initialize_params input. The GCE disk type. May be set to pd-standard, pd-balanced or pd-ssd."
  type        = string
  default     = null
}

variable "workspace_deeplearning_vm_disk_image" {
  description = "Placeholder variable to define initialize_params input. The image from which to initialize this disk. More detail can be found with the command `gcloud compute images list`. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}. If referred by family, the images names must include the family name. If they don't, use the google_compute_image data source. For instance, the image centos-6-v20180104 includes its family name centos-6. These images can be referred by family name here."
  type        = string
  default     = null
}

// NETWORK INTERFACE

variable "workspace_deeplearning_vm_subnetwork" {
  description = "The name or self_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. If network isn't provided it will be inferred from the subnetwork. Either network or subnetwork must be provided."
  type        = string
  default     = ""
}

variable "workspace_deeplearning_vm_network_ip" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned."
  type        = string
  default     = ""
}

// SERVICE ACCOUNT

variable "workspace_deeplearning_vm_service_account_email" {
  description = "The service account e-mail address. If not given, the default Google Compute Engine service account is used. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = string
  default     = ""
}

variable "workspace_deeplearning_vm_service_account_scopes" {
  description = "A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope. See a complete list of scopes [here](https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes). Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = list(string)
  default     = []
}

// SHIELDED INSTANCE CONFIGURATION

variable "workspace_deeplearning_vm_enable_secure_boot" {
  description = "Verify the digital signature of all boot components, and halt the boot process if signature verification fails. Defaults to false. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = bool
  default     = false
}

variable "workspace_deeplearning_vm_enable_vtpm" {
  description = "Use a virtualized trusted platform module, which is a specialized computer chip you can use to encrypt objects like keys and certificates. Defaults to true. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = bool
  default     = true
}

variable "workspace_deeplearning_vm_enable_integrity_monitoring" {
  description = "Compare the most recent boot measurements to the integrity policy baseline and return a pair of pass/fail results depending on whether they match or not. Defaults to true. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = bool
  default     = true
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

#--------------------------------------
# RESEARCHER BASTION PROJECT VARIABLES
#--------------------------------------

variable "bastion_project_default_service_account" {
  description = "Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
  type        = string
  default     = "delete"
}


#---------------------------------------------------------
# RESEARCHER BASTION PROJECT IAM MEMBER BINDING VARIABLES
#---------------------------------------------------------

variable "bastion_project_member" {
  description = "The member to apply the IAM role to. Possible options use the following syntax: user:{emailid}, serviceAccount:{emailid}, group:{emailid}, domain:{domain}."
  type        = string
  default     = ""
}

variable "bastion_project_iam_role_list" {
  description = "The IAM role(s) to assign to the member at the defined project."
  type        = list(string)
  default     = []
}

#-----------------------------------------------------
# RESEARCHER BASTION PROJECT IAM CUSTOM ROLE VARIABLES
#-----------------------------------------------------

variable "bastion_project_iam_custom_role_project_id" {
  description = "The project that the custom role will be created in. Defaults to the provider project configuration."
  type        = string
  default     = ""
}

variable "bastion_project_iam_custom_role_description" {
  description = "A human-readable description for the role."
  type        = string
  default     = "Custom role created with Terraform."
}

variable "bastion_project_iam_custom_role_id" {
  description = "The camel case role id to use for this role. Cannot contain - characters."
  type        = string
  default     = ""
}

variable "bastion_project_iam_custom_role_title" {
  description = "A human-readable title for the role."
  type        = string
  default     = ""
}

variable "bastion_project_iam_custom_role_permissions" {
  description = "The names of the permissions this role grants when bound in an IAM policy. At least one permission must be specified."
  type        = list(string)
  default     = []
}

variable "bastion_project_iam_custom_role_stage" {
  description = "The current launch stage of the role. Defaults to GA. List of possible stages is [here](https://cloud.google.com/iam/docs/reference/rest/v1/organizations.roles#Role.RoleLaunchStage)."
  type        = string
  default     = ""
}

#-------------------------------------------
# RESEARCHER BASTION PROJECT - VPC VARIABLES
#-------------------------------------------

variable "bastion_project_vpc_delete_default_internet_gateway_routes" {
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  type        = bool
  default     = true
}

variable "bastion_project_vpc_routing_mode" {
  description = "The network routing mode for regional dynamic routing or global dynamic routing (default 'GLOBAL' otherwise use 'REGIONAL')"
  type        = string
  default     = "GLOBAL"
}

variable "bastion_project_vpc_description" {
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  type        = string
  default     = "VPC created from Terraform for web app use case deployment."
}

variable "bastion_project_vpc_mtu" {
  type        = number
  description = "The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically."
}

variable "bastion_project_vpc_subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default     = []
}

variable "bastion_project_vpc_secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "bastion_project_vpc_routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC. For more information see [link](https://github.com/terraform-google-modules/terraform-google-network#route-inputs)"
  default     = []
}

#--------------------------------------------------
# RESEARCHER BASTION PROJECT VPC FIREWALL VARIABLES
#--------------------------------------------------

variable "bastion_project_firewall_custom_rules" {
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

#------------------------------------------------------
# RESEARCHER BASTION TO WORKSPACE VPC PEERING VARIABLES
#------------------------------------------------------

variable "researcher_bastion_to_workspace_export_custom_routes" {
  description = "Whether to export the custom routes to the peer network. Defaults to false."
  type        = bool
  default     = true
}

variable "researcher_bastion_to_workspace_import_custom_routes" {
  description = "Whether to import the custom routes from the peer network. Defaults to false."
  type        = bool
  default     = true
}

variable "researcher_bastion_to_workspace_export_subnet_routes_with_public_ip" {
  description = "Whether subnet routes with public IP range are exported. The default value is false, all subnet routes are exported. The IPv4 special-use ranges (https://en.wikipedia.org/wiki/IPv4#Special_addresses) are always exported to peers and are not controlled by this field."
  type        = bool
  default     = true
}

variable "researcher_bastion_to_workspace_import_subnet_routes_with_public_ip" {
  description = "Whether subnet routes with public IP range are imported. The default value is false. The IPv4 special-use ranges (https://en.wikipedia.org/wiki/IPv4#Special_addresses) are always imported from peers and are not controlled by this field."
  type        = bool
  default     = true
}

#-------------------------------------------------------
# RESEARCHER BASTION PROJECT - SERVICE ACCOUNT VARIABLES
#-------------------------------------------------------

variable "bastion_project_sa_display_name" {
  type        = string
  description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
  default     = "Terraform-managed service account"
}

variable "bastion_project_sa_generate_keys" {
  description = "Generate keys for service accounts."
  type        = bool
  default     = false
}

variable "bastion_project_sa_grant_billing_role" {
  description = "Grant billing user role."
  type        = bool
  default     = false
}

variable "bastion_project_sa_grant_xpn_roles" {
  description = "Grant roles for shared VPC management."
  type        = bool
  default     = false
}

variable "bastion_project_sa_service_account_names" {
  description = "Names of the service accounts to create."
  type        = list(string)
  default     = [""]
}

variable "bastion_project_sa_prefix" {
  description = "Prefix applied to service account names."
  type        = string
  default     = ""
}

#---------------------------------------------------------------------
# RESEARCHER BASTION VM SERVICE ACCOUNT - PROJECT IAM MEMBER VARIABLES
#---------------------------------------------------------------------

variable "bastion_vm_sa_project_iam_role_list" {
  description = "The IAM role(s) to assign to the Bastion Project VM's Service Account at the defined project."
  type        = list(string)
  default     = []
}

#---------------------------------------------
# RESEARCHER BASTION VM - PRIVATE IP VARIABLES
#---------------------------------------------

variable "num_instances_researcher_bastion_vms" {
  description = "Number of instances to create."
  type        = number
  default     = 0
}

variable "bastion_vm_allow_stopping_for_update" {
  description = "If true, allows Terraform to stop the instance to update its properties. If you try to update a property that requires stopping the instance without setting this field, the update will fail."
  type        = bool
  default     = true
}

variable "bastion_vm_description" {
  description = "A description of the VM instance."
  type        = string
  default     = "VM created with Terraform"
}

variable "bastion_vm_desired_status" {
  description = "Desired status of the instance. Either `RUNNING` or `TERMINATED`."
  type        = string
  default     = "RUNNING"
}

variable "bastion_vm_deletion_protection" {
  description = "Enable deletion protection on this instance. Defaults to false. You must disable deletion protection before the resource can be removed (e.g., via terraform destroy). Otherwise the instance cannot be deleted and the Terraform run will not complete successfully."
  type        = bool
  default     = false
}

variable "bastion_vm_labels" {
  description = "A map of key/value label pairs to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "bastion_vm_metadata" {
  description = "Metadata key/value pairs to make available from within the instance. SSH keys attached in the Cloud Console will be removed. Add them to your configuration in order to keep them attached to your instance."
  type        = map(string)
  default     = {}
}

variable "bastion_vm_metadata_startup_script" {
  description = "An alternative to using the startup-script metadata key, except this one forces the instance to be recreated (thus re-running the script) if it is changed. This replaces the startup-script metadata key on the created instance and thus the two mechanisms are not allowed to be used simultaneously. Users are free to use either mechanism - the only distinction is that this separate attribute will cause a recreate on modification. On import, metadata_startup_script will be set, but metadata.startup-script will not - if you choose to use the other mechanism, you will see a diff immediately after import, which will cause a destroy/recreate operation. You may want to modify your state file manually using terraform state commands, depending on your use case."
  type        = string
  default     = ""
}

variable "bastion_vm_machine_type" {
  description = "The machine type to create. For example `n2-standard-2`."
  type        = string
  default     = ""
}

variable "bastion_vm_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  type        = string
}

variable "bastion_vm_tags" {
  description = "A list of network tags to attach to the instance."
  type        = list(string)
  default     = []
}

// BOOT DISK BLOCK VARIABLES

variable "bastion_vm_auto_delete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted. Defaults to true."
  type        = bool
  default     = true
}

variable "bastion_vm_device_name" {
  description = "Name with which attached disk will be accessible. On the instance, this device will be `/dev/disk/by-id/google-{{device_name}}`."
  type        = string
  default     = ""
}

variable "bastion_vm_disk_mode" {
  description = "The mode in which to attach this disk, either READ_WRITE or READ_ONLY. If not specified, the default is to attach the disk in READ_WRITE mode."
  type        = string
  default     = "READ_WRITE"
}

variable "bastion_vm_kms_key_self_link" {
  description = "The self_link of the encryption key that is stored in Google Cloud KMS to encrypt this disk. Only one of kms_key_self_link and disk_encryption_key_raw may be set."
  type        = string
  default     = ""
}

variable "bastion_vm_source_disk" {
  description = "The name or self_link of the existing disk (such as those managed by google_compute_disk) or disk image. To create an instance from a snapshot, first create a google_compute_disk from a snapshot and reference it here."
  type        = string
  default     = ""
}


variable "bastion_vm_disk_size" {
  description = "Placeholder variable to define initialize_params input. The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  type        = number
  default     = null
}

variable "bastion_vm_disk_type" {
  description = "Placeholder variable to define initialize_params input. The GCE disk type. May be set to pd-standard, pd-balanced or pd-ssd."
  type        = string
  default     = null
}

variable "bastion_vm_disk_image" {
  description = "Placeholder variable to define initialize_params input. The image from which to initialize this disk. More detail can be found with the command `gcloud compute images list`. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}. If referred by family, the images names must include the family name. If they don't, use the google_compute_image data source. For instance, the image centos-6-v20180104 includes its family name centos-6. These images can be referred by family name here."
  type        = string
  default     = null
}

// NETWORK INTERFACE

variable "bastion_vm_subnetwork" {
  description = "The name or self_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. If network isn't provided it will be inferred from the subnetwork. Either network or subnetwork must be provided."
  type        = string
  default     = ""
}

variable "bastion_vm_network_ip" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned."
  type        = string
  default     = ""
}

// SERVICE ACCOUNT

variable "bastion_vm_service_account_email" {
  description = "The service account e-mail address. If not given, the default Google Compute Engine service account is used. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = string
  default     = ""
}

variable "bastion_vm_service_account_scopes" {
  description = "A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope. See a complete list of scopes [here](https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes). Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = list(string)
  default     = []
}

// SHIELDED INSTANCE CONFIGURATION

variable "bastion_vm_enable_secure_boot" {
  description = "Verify the digital signature of all boot components, and halt the boot process if signature verification fails. Defaults to false. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = bool
  default     = false
}

variable "bastion_vm_enable_vtpm" {
  description = "Use a virtualized trusted platform module, which is a specialized computer chip you can use to encrypt objects like keys and certificates. Defaults to true. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = bool
  default     = true
}

variable "bastion_vm_enable_integrity_monitoring" {
  description = "Compare the most recent boot measurements to the integrity policy baseline and return a pair of pass/fail results depending on whether they match or not. Defaults to true. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = bool
  default     = true
}

#--------------------------------------------------------
# BASTION PROJECT - REGIONAL EXTERNAL STATIC IP VARIABLES
#---------------------------------------------------------

variable "bastion_project_regional_external_static_ip_project_id" {
  description = "The project ID to provision this resource into."
  type        = string
  default     = ""
}

variable "bastion_project_regional_external_static_ip_address_type" {
  description = "The type of address to reserve. Default value is EXTERNAL. Possible values are INTERNAL and EXTERNAL."
  type        = string
  default     = "EXTERNAL"
}

variable "bastion_project_regional_external_static_ip_description" {
  description = "The description to attach to the IP address."
  type        = string
  default     = "Created with Terraform"
}

variable "bastion_project_regional_external_static_ip_network_tier" {
  description = "The networking tier used for configuring this address. If this field is not specified, it is assumed to be PREMIUM. Possible values are PREMIUM and STANDARD."
  type        = string
  default     = "PREMIUM"
}

variable "bastion_project_regional_external_static_ip_region" {
  description = "The Region in which the created address should reside. If it is not provided, the provider region is used."
  type        = string
  default     = ""
}

#--------------------------------------
# BASTION PROJECT - CLOUD NAT VARIABLES
#--------------------------------------

variable "bastion_project_project_id" {
  description = "The project ID to deploy to."
  type        = string
  default     = ""
}

variable "bastion_project_router_asn" {
  description = "Router ASN, only if router is not passed in and is created by the module."
  type        = string
  default     = "64514"
}

variable "bastion_project_cloud_nat_subnetworks" {
  description = "The subnetwork to use Cloud NAT with."
  type = list(object({
    name                     = string,
    source_ip_ranges_to_nat  = list(string)
    secondary_ip_range_names = list(string)
  }))
  default = []
}

variable "bastion_project_enable_endpoint_independent_mapping" {
  description = "Specifies if endpoint independent mapping is enabled."
  type        = bool
  default     = null
}

variable "bastion_project_icmp_idle_timeout_sec" {
  description = "Timeout (in seconds) for ICMP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "30"
}

variable "bastion_project_log_config_enable" {
  description = "Indicates whether or not to export logs"
  type        = bool
  default     = false
}

variable "bastion_project_log_config_filter" {
  description = "Specifies the desired filtering of logs on this NAT. Valid values are: \"ERRORS_ONLY\", \"TRANSLATIONS_ONLY\", \"ALL\""
  type        = string
  default     = "ALL"
}

variable "bastion_project_min_ports_per_vm" {
  description = "Minimum number of ports allocated to a VM from this NAT config. Defaults to 64 if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "64"
}

variable "bastion_project_nat_ip_allocate_option" {
  description = "Value inferred based on nat_ips. If present set to MANUAL_ONLY, otherwise AUTO_ONLY."
  type        = string
  default     = "false"
}

variable "bastion_project_nat_ips" {
  description = "List of self_links of external IPs. Changing this forces a new NAT to be created."
  type        = list(string)
  default     = []
}

variable "bastion_project_source_subnetwork_ip_ranges_to_nat" {
  description = "Defaults to ALL_SUBNETWORKS_ALL_IP_RANGES. How NAT should be configured per Subnetwork. Valid values include: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS. Changing this forces a new NAT to be created."
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "bastion_project_tcp_established_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "1200"
}

variable "bastion_project_tcp_transitory_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "30"
}

variable "bastion_project_udp_idle_timeout_sec" {
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

#----------------------------------------------
# BASTION PROEJCT SERVICE ACCOUNT CREATION
#----------------------------------------------

variable "enforce_bastion_project_disable_sa_creation" {
  description = "Define variable to disable and enable policy at the project level during provisioning."
  type        = bool
  default     = true
}