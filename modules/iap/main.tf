#------------
# IAP MODULE
#------------

module "iap_tunneling" {
  source  = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"
  version = "~> 3.2.0"

  // REQUIRED
  project   = var.project
  instances = var.instances
  members   = var.iap_members
  network   = var.network_self_link

  // OPTIONAL
  additional_ports           = var.additional_ports
  create_firewall_rule       = var.create_firewall_rule
  fw_name_allow_ssh_from_iap = var.fw_name_allow_ssh_from_iap
  host_project               = var.host_project
  network_tags               = var.network_tags
}