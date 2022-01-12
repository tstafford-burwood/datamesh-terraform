# Terraform Module for Provisioning VPC Routes

The purpose of this directory is to provision custom routes in a GCP VPC.

## Usage

Below is an example of how to use this module.

```terraform
module "vpc_routes" {
  source  = "./modules/vpc_routes"

  vpc_project_id    = "project1234"
  vpc_network_name  = "my_network"
  vpc_routes        = {
    name                   = "egress-internet"
    description            = "route through IGW to access internet"
    destination_range      = "0.0.0.0/0"
    tags                   = "egress-inet"
    next_hop_internet      = "true"
}
  module_depends_on = [var.module_depends_on]
}
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| vpc_routes | terraform-google-modules/network/google//modules/routes | ~> 3.4.0 |

### Routes Input

The routes list contains maps, where each object represents a route. For the next_hop_* inputs, only one is possible to be used in each route. Having two next_hop_* inputs will produce an error. Each map has the following inputs (please see examples folder for additional references):

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The name of the route being created  | string | - | no |
| description | The description of the route being created | string | - | no |
| tags | The network tags assigned to this route. This is a list in string format. Eg. "tag-01,tag-02"| string | - | yes |
| destination\_range | The destination range of outgoing packets that this route applies to. Only IPv4 is supported | string | - | yes
| next\_hop\_internet | Whether the next hop to this route will the default internet gateway. Use "true" to enable this as next hop | string | `"false"` | yes |
| next\_hop\_ip | Network IP address of an instance that should handle matching packets | string | - | yes |
| next\_hop\_instance |  URL or name of an instance that should handle matching packets. If just name is specified "next\_hop\_instance\_zone" is required | string | - | yes |
| next\_hop\_instance\_zone |  The zone of the instance specified in next\_hop\_instance. Only required if next\_hop\_instance is specified as a name | string | - | no |
| next\_hop\_vpn\_tunnel | URL to a VpnTunnel that should handle matching packets | string | - | yes |
| next\_hop\_ilb | The URL to a forwarding rule of type loadBalancingScheme=INTERNAL that should handle matching packets. | string | - | no |
| priority | The priority of this route. Priority is used to break ties in cases where there is more than one matching route of equal prefix length. In the case of two routes with equal prefix length, the one with the lowest-numbered priority value wins | string | `"1000"` | yes |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| module\_depends\_on | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| vpc\_network\_name | The name of the network where routes will be created | `any` | n/a | yes |
| vpc\_project\_id | The ID of the project where the routes will be created | `any` | n/a | yes |
| vpc\_routes | List of routes being created in this VPC | `list(map(string))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| routes | The created routes resources |