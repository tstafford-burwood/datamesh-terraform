#-----------------
# CLOUD NAT MODULE
#-----------------

module "cloud_nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 2.0.0"

  create_router                       = var.create_router
  project_id                          = var.project_id
  name                                = var.cloud_nat_name
  network                             = var.cloud_nat_network
  region                              = var.region
  router                              = var.router_name
  router_asn                          = var.router_asn
  subnetworks                         = var.cloud_nat_subnetworks
  enable_endpoint_independent_mapping = var.enable_endpoint_independent_mapping
  icmp_idle_timeout_sec               = var.icmp_idle_timeout_sec
  log_config_enable                   = var.log_config_enable
  log_config_filter                   = var.log_config_filter
  min_ports_per_vm                    = var.min_ports_per_vm
  nat_ip_allocate_option              = var.nat_ip_allocate_option
  nat_ips                             = var.nat_ips
  source_subnetwork_ip_ranges_to_nat  = var.source_subnetwork_ip_ranges_to_nat
  tcp_established_idle_timeout_sec    = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.tcp_transitory_idle_timeout_sec
  udp_idle_timeout_sec                = var.udp_idle_timeout_sec
}