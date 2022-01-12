#----------------------
# VPC PEERING VARIABLES
#----------------------

variable "vpc_peering_name" {
  description = "Name of the peering."
  type        = string
  default     = ""
}

variable "vpc_network_name" {
  description = "The primary network of the peering."
  type        = string
  default     = ""
}

variable "peer_network_name" {
  description = "The peer network in the peering. The peer network may belong to a different project."
  type        = string
  default     = ""
}

variable "export_custom_routes" {
  description = "Whether to export the custom routes to the peer network. Defaults to false."
  type        = bool
  default     = false
}

variable "import_custom_routes" {
  description = "Whether to import the custom routes from the peer network. Defaults to false."
  type        = bool
  default     = false
}

variable "export_subnet_routes_with_public_ip" {
  description = "Whether subnet routes with public IP range are exported. The default value is false, all subnet routes are exported. The IPv4 special-use ranges (https://en.wikipedia.org/wiki/IPv4#Special_addresses) are always exported to peers and are not controlled by this field."
  type        = bool
  default     = false
}

variable "import_subnet_routes_with_public_ip" {
  description = "Whether subnet routes with public IP range are imported. The default value is false. The IPv4 special-use ranges (https://en.wikipedia.org/wiki/IPv4#Special_addresses) are always imported from peers and are not controlled by this field."
  type        = bool
  default     = false
}