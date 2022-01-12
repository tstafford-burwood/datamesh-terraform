#-----------------------
# STANDALONE VPC MODULE
#-----------------------

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id                             = var.project_id
  network_name                           = var.vpc_network_name
  auto_create_subnetworks                = var.auto_create_subnetworks
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes
  firewall_rules                         = var.firewall_rules
  routing_mode                           = var.routing_mode
  description                            = var.vpc_description
  shared_vpc_host                        = var.shared_vpc_host
  mtu                                    = var.mtu
  subnets                                = var.subnets
  secondary_ranges                       = var.secondary_ranges
  routes                                 = var.routes
}