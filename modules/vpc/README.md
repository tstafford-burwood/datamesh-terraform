# Terraform Module for Single VPC

This module will provision a VPC within a project and can define subnets, secondary ranges for subnets, and custom VPC routes.

## Usage

Below is an example of how to use this module.

```terraform
module "vpc" {
    source  = "./modules/vpc"
    version = "~> 3.0"

    project_id   = "<PROJECT ID>"
    network_name = "example-vpc"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-west1"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "This subnet has a description"
        },
        {
            subnet_name               = "subnet-03"
            subnet_ip                 = "10.10.30.0/24"
            subnet_region             = "us-west1"
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_10_MIN"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        }
    ]

    secondary_ranges = {
        subnet-01 = [
            {
                range_name    = "subnet-01-secondary-01"
                ip_cidr_range = "192.168.64.0/24"
            },
        ]
    }
}
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| vpc | terraform-google-modules/network/google | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_create\_subnetworks | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| delete\_default\_internet\_gateway\_routes | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `false` | no |
| firewall\_rules | List of firewall rules | `any` | `[]` | no |
| mtu | The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically. | `number` | n/a | yes |
| project\_id | The ID of the project where this VPC will be created | `string` | n/a | yes |
| routes | List of routes being created in this VPC. For more information see [link](https://github.com/terraform-google-modules/terraform-google-network#route-inputs) | `list(map(string))` | `[]` | no |
| routing\_mode | The network routing mode for regional dynamic routing or global dynamic routing (default 'GLOBAL' otherwise use 'REGIONAL') | `string` | `"GLOBAL"` | no |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| shared\_vpc\_host | Makes this project a Shared VPC host if 'true' (default 'false') | `bool` | `false` | no |
| subnets | The list of subnets being created | `list(map(string))` | `[]` | no |
| vpc\_description | An optional description of this resource. The resource must be recreated to modify this field. | `string` | `"VPC created from Terraform for web app use case deployment."` | no |
| vpc\_network\_name | The name of the network being created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| route\_names | The routes associated with this VPC. |
| subnets\_names | The names of the subnets being created |
| subnets\_self\_links | The self-links of subnets being created |