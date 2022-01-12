#-------------------
# VPC PEERING MODULE
#-------------------

resource "google_compute_network_peering" "peering" {
  name                                = var.vpc_peering_name
  network                             = var.vpc_network_name
  peer_network                        = var.peer_network_name
  export_custom_routes                = var.export_custom_routes
  import_custom_routes                = var.import_custom_routes
  export_subnet_routes_with_public_ip = var.export_subnet_routes_with_public_ip
  import_subnet_routes_with_public_ip = var.import_subnet_routes_with_public_ip
}