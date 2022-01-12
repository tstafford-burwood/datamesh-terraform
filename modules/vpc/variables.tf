#--------------------------------
# STANDALONE VPC MODULE VARIABLES
#--------------------------------

variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "vpc_network_name" {
  description = "The name of the network being created"
  type        = string
}

variable "auto_create_subnetworks" {
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  type        = bool
  default     = false
}

variable "delete_default_internet_gateway_routes" {
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  type        = bool
  default     = false
}

variable "firewall_rules" {
  description = "List of firewall rules"
  type        = any
  default     = []
}

variable "routing_mode" {
  description = "The network routing mode for regional dynamic routing or global dynamic routing (default 'GLOBAL' otherwise use 'REGIONAL')"
  type        = string
  default     = "GLOBAL"
}

variable "vpc_description" {
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  type        = string
  default     = "VPC created from Terraform for web app use case deployment."
}

variable "shared_vpc_host" {
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
  type        = bool
  default     = false
}

variable "mtu" {
  type        = number
  description = "The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically."
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default     = []
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC. For more information see [link](https://github.com/terraform-google-modules/terraform-google-network#route-inputs)"
  default     = []
}