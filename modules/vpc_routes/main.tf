#------------------
# VPC ROUTES MODULE
#------------------

module "vpc_routes" {
  source  = "terraform-google-modules/network/google//modules/routes"
  version = "~> 3.4.0"

  project_id        = var.vpc_project_id
  network_name      = var.vpc_network_name
  routes            = var.vpc_routes
  module_depends_on = [var.module_depends_on]
}