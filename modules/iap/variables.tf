#--------------
# IAP VARIABLES
#--------------

// REQUIRED

variable "project" {
  description = "The project ID to deploy to."
  type        = string
}

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

variable "network_self_link" {
  description = "Self link of the network to attach the firewall to."
  type        = string
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