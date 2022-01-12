#--------------------
# CLOUD NAT VARIABLES
#--------------------

variable "create_router" {
  description = "Create router instead of using an existing one, uses 'router' variable for new resource name."
  type        = bool
  default     = false
}

variable "project_id" {
  description = "The project ID to deploy to."
  type        = string
  default     = ""
}

variable "cloud_nat_name" {
  description = "Defaults to 'cloud-nat-RANDOM_SUFFIX'. Changing this forces a new NAT to be created."
  type        = string
  default     = ""
}

variable "cloud_nat_network" {
  description = "VPC name, only if router is not passed in and is created by the module."
  type        = string
  default     = ""
}

variable "region" {
  description = "The region to deploy to."
  type        = string
  default     = ""
}

variable "router_name" {
  description = "The name of the router in which this NAT will be configured. Changing this forces a new NAT to be created."
  type        = string
  default     = ""
}

variable "router_asn" {
  description = "Router ASN, only if router is not passed in and is created by the module."
  type        = string
  default     = "64514"
}

variable "cloud_nat_subnetworks" {
  description = "The subnetwork to use Cloud NAT with."
  type = list(object({
    name                     = string,
    source_ip_ranges_to_nat  = list(string)
    secondary_ip_range_names = list(string)
  }))
  default = []
}

variable "enable_endpoint_independent_mapping" {
  description = "Specifies if endpoint independent mapping is enabled."
  type        = bool
  default     = null
}

variable "icmp_idle_timeout_sec" {
  description = "Timeout (in seconds) for ICMP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "30"
}

variable "log_config_enable" {
  description = "Indicates whether or not to export logs"
  type        = bool
  default     = false
}

variable "log_config_filter" {
  description = "Specifies the desired filtering of logs on this NAT. Valid values are: \"ERRORS_ONLY\", \"TRANSLATIONS_ONLY\", \"ALL\""
  type        = string
  default     = "ALL"
}

variable "min_ports_per_vm" {
  description = "Minimum number of ports allocated to a VM from this NAT config. Defaults to 64 if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "64"
}

variable "nat_ip_allocate_option" {
  description = "Value inferred based on nat_ips. If present set to MANUAL_ONLY, otherwise AUTO_ONLY."
  type        = string
  default     = "false"
}

variable "nat_ips" {
  description = "List of self_links of external IPs. Changing this forces a new NAT to be created."
  type        = list(string)
  default     = []
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "Defaults to ALL_SUBNETWORKS_ALL_IP_RANGES. How NAT should be configured per Subnetwork. Valid values include: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS. Changing this forces a new NAT to be created."
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "tcp_established_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "1200"
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "30"
}

variable "udp_idle_timeout_sec" {
  description = "Timeout (in seconds) for UDP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  type        = string
  default     = "30"
}