#------------------------------------
# RESEARCHER WORKSPACE PROJECT TFVARS
#------------------------------------

// RESEARCHER WORKSPACE TFVARS - OPTIONAL
#workspace_default_service_account = "keep"


#-------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM MEMBER BINDING TFVARS
#-------------------------------------------------------

# TODO: Update IAM permissions for researchers

workspace_project_iam_role_list = [
  "roles/compute.osLogin",
  "roles/iam.serviceAccountUser",
  "roles/iap.tunnelResourceAccessor"
]

#--------------------------------
# RESEARCHER WORKSPACE VPC TFVARS
#--------------------------------

workspace_vpc_delete_default_internet_gateway_routes = true
workspace_vpc_firewall_rules                         = []
workspace_vpc_routing_mode                           = "GLOBAL"
workspace_vpc_mtu                                    = 1460

workspace_vpc_routes = [
  {
    name              = "private-google-apis-and-iap-tunnel-custom-route"
    description       = "Custom VPC Route for Private Google API and IAP tunnel access."
    tags              = "deep-learning-vm"
    destination_range = "199.36.153.8/30"
    next_hop_internet = "true"
    priority          = 10
  },
  # {
  #   name              = "srde-private-google-apis-custom-route"
  #   description       = "Custom VPC Route for Private Google API."
  #   tags              = "path-ml-vm"
  #   destination_range = "199.36.153.8/30"
  #   next_hop_internet = "true"
  #   priority          = 10
  # },
  {
    name              = "deep-learning-vm-ping-8-8-8-8"
    description       = "Custom VPC Route used to ping 8.8.8.8/32"
    tags              = "deep-learning-vm"
    destination_range = "8.8.8.8/32"
    next_hop_internet = "true"
    priority          = 20
  }
]

#-----------------------------------------------------
# RESEARCHER WORKSPACE RESTRICTED API CLOUD DNS TFVARS
#-----------------------------------------------------

workspace_restricted_api_cloud_dns_recordsets = [
  {
    name    = "*"
    type    = "CNAME"
    ttl     = 300
    records = ["restricted.googleapis.com."]
  },
  {
    name = "restricted"
    type = "A"
    ttl  = 300
    records = [
      "199.36.153.4",
      "199.36.153.5",
      "199.36.153.6",
      "199.36.153.7"
    ]
  },
  {
    name    = "notebooks"
    type    = "CNAME"
    ttl     = 300
    records = ["restricted.googleapis.com."]
  },
    {
    name    = "*.notebooks"
    type    = "CNAME"
    ttl     = 300
    records = ["restricted.googleapis.com."]
  }
]

workspace_notebooks_google_cloud_dns_recordsets = [
  {
    name    = "*"
    type    = "CNAME"
    ttl     = 300
    records = ["notebooks.cloud.google.com."]
  },
  {
    name = "restricted"
    type = "A"
    ttl  = 300
    records = [
      "142.250.190.78"
    ]
  }
]

workspace_notebooks_googleusercontent_dns_recordsets = [
  {
    name    = "*"
    type    = "CNAME"
    ttl     = 300
    records = ["notebooks.googleusercontent.com."]
  },
  {
    name = "restricted"
    type = "A"
    ttl  = 300
    records = [
      "172.217.1.97"
    ]
  }
]

#-------------------------------------------------
# RESEARCHER WORKSPACE IAP TUNNEL CLOUD DNS TFVARS
#-------------------------------------------------

workspace_iap_tunnel_cloud_dns_recordsets = [
  {
    name    = "*"
    type    = "CNAME"
    ttl     = 300
    records = ["tunnel.cloudproxy.app."]
  },
  {
    name = ""
    type = "A"
    ttl  = 300
    records = [
      "199.36.153.8",
      "199.36.153.9",
      "199.36.153.10",
      "199.36.153.11"
    ]
  }
]

#--------------------------------------------------------
# RESEARCHER WORKSPACE ARTIFACT REGISTRY CLOUD DNS TFVARS
#--------------------------------------------------------

workspace_artifact_registry_cloud_dns_recordsets = [
  {
    name    = "*"
    type    = "CNAME"
    ttl     = 300
    records = ["pkg.dev."]
  },
  {
    name = ""
    type = "A"
    ttl  = 300
    records = [
      "199.36.153.8",
      "199.36.153.9",
      "199.36.153.10",
      "199.36.153.11"
    ]
  }
]

#-----------------------------------------
# WORKSPACE FIREWALL
#-----------------------------------------

workspace_firewall_custom_rules = {
  deep-learning-vm-allow-egress-to-private-google-apis = {
    description          = "Allow egress from Deep Learning Workspace VM to Private Google APIs Virtual IP."
    direction            = "EGRESS"
    action               = "allow"
    ranges               = ["199.36.153.8/30"]
    sources              = []
    targets              = ["deep-learning-vm"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["443"]
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 5
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  
  deep-learning-vm-allow-8-8-8-8-icmp = {
    description          = "Allow Deep Learning Workspace VM to ping 8.8.8.8/32."
    direction            = "EGRESS"
    action               = "allow"
    ranges               = ["8.8.8.8/32"]
    sources              = []
    targets              = ["deep-learning-vm"]
    use_service_accounts = false
    rules = [
      {
        protocol = "icmp"
        ports    = []
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 10
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  all-workspace-vm-deny-all-other-egress = {
    description          = "Block all other egress from any VM in the Workspace project."
    direction            = "EGRESS"
    action               = "deny"
    ranges               = ["0.0.0.0/0"]
    sources              = []
    targets              = []
    use_service_accounts = false
    rules = [
      {
        protocol = "all"
        ports    = []
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 50
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  deep-learning-vm-allow-ssh-ingress-from-bastion = {
    description          = "Allow SSH connection into Workspace VM."
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["10.10.0.2/32"]
    sources              = ["bastion-vm"]
    targets              = ["deep-learning-vm"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["22"]
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 5
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  },
  all-workspace-vm-deny-all-other-ingress = {
    description          = "Deny all other ingress to any Workspace VMs."
    direction            = "INGRESS"
    action               = "deny"
    ranges               = ["0.0.0.0/0"]
    sources              = []
    targets              = []
    use_service_accounts = false
    rules = [
      {
        protocol = "all"
        ports    = []
      }
    ]
    extra_attributes = {
      "disabled" : false
      "priority" : 40
    }
    flow_logs_metadata = "INCLUDE_ALL_METADATA"
  }
}

#----------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM CUSTOM ROLE TFVARS
#----------------------------------------------------

workspace_project_iam_custom_role_description = "Custom SRDE Role for Workspace project operations."
workspace_project_iam_custom_role_id          = "srdeCustomRoleWorkspaceProjectOperations"
workspace_project_iam_custom_role_title       = "[Custom] SRDE Workspace Project Operations Role"
workspace_project_iam_custom_role_permissions = ["storage.buckets.list", "storage.objects.list", "storage.objects.get", "storage.objects.create"] # TODO: Update this if needed.
workspace_project_iam_custom_role_stage       = "GA"



#-----------------------------------
# RESEARCHER WORKSPACE - REGIONAL EXTERNAL STATIC IP TFVARS
#-----------------------------------

// OPTIONAL
researcher_workspace_regional_external_static_ip_address_type = "EXTERNAL"
researcher_workspace_regional_external_static_ip_description  = "Regional External Static IP for Researcher Workspace to use with Cloud NAT."
researcher_workspace_regional_external_static_ip_network_tier = "PREMIUM"

#----------------------------------------
# RESEARCHER WORKSPACE - CLOUD NAT TFVARS
#----------------------------------------

researcher_workspace_create_router                       = true
researcher_workspace_router_asn                          = "64514"
researcher_workspace_enable_endpoint_independent_mapping = null
researcher_workspace_icmp_idle_timeout_sec               = "30"
researcher_workspace_log_config_enable                   = true
researcher_workspace_log_config_filter                   = "ALL"
researcher_workspace_min_ports_per_vm                    = "64"
researcher_workspace_source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"
researcher_workspace_tcp_established_idle_timeout_sec    = "1200"
researcher_workspace_tcp_transitory_idle_timeout_sec     = "30"
researcher_workspace_udp_idle_timeout_sec                = "30"


#-----------
# IAP TFVARS
#-----------

// FIREWALL RULE BEING MADE IN BASTION VPC FIREWALL MODULE TFVARS

instances                  = []
iap_members                = []
additional_ports           = []
create_firewall_rule       = false
fw_name_allow_ssh_from_iap = "allow-ssh-from-iap-to-tunnel"
host_project               = ""

#--------------------------------------
# RESEARCHER DATA EGRESS PROJECT TFVARS
#--------------------------------------

// RESEARCHER DATA EGRESS PROJECT TFVARS - OPTIONAL

egress_default_service_account = "disable"