# Terraform Directory for Provisioning A VPC Peering Setup

The purpose of this directory is to establish VPC peer in one direction with another declared network. Peering will need to be established from each VPC to the other VPC so this module should be used twice when peering two VPC networks to each other.

# Notes
* Subnets cannot overlap when peering two VPC networks to each other.

## Usage

Below is an example of how to use this module.

```terraform
module "vpc_peering" {

  source = "../../../../modules/vpc_peering"

  vpc_peering_name                    = "vpc1_peer_to_vpc2"
  vpc_network_name                    = "vpc1_network_name"
  peer_network_name                   = "vpc2_network_name"
  export_custom_routes                = true
  import_custom_routes                = true
  export_subnet_routes_with_public_ip = true
  import_subnet_routes_with_public_ip = true
}
```
## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Resources

| Name |
|------|
| [google_compute_network_peering](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| export\_custom\_routes | Whether to export the custom routes to the peer network. Defaults to false. | `bool` | `false` | no |
| export\_subnet\_routes\_with\_public\_ip | Whether subnet routes with public IP range are exported. The default value is false, all subnet routes are exported. The IPv4 special-use ranges (https://en.wikipedia.org/wiki/IPv4#Special_addresses) are always exported to peers and are not controlled by this field. | `bool` | `false` | no |
| import\_custom\_routes | Whether to import the custom routes from the peer network. Defaults to false. | `bool` | `false` | no |
| import\_subnet\_routes\_with\_public\_ip | Whether subnet routes with public IP range are imported. The default value is false. The IPv4 special-use ranges (https://en.wikipedia.org/wiki/IPv4#Special_addresses) are always imported from peers and are not controlled by this field. | `bool` | `false` | no |       
| peer\_network\_name | The peer network in the peering. The peer network may belong to a different project. | `string` | `""` | no |
| vpc\_network\_name | The primary network of the peering. | `string` | `""` | no |
| vpc\_peering\_name | Name of the peering. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | An identifier for the resource with format {{network}}/{{name}} |
| state | State for the peering, either ACTIVE or INACTIVE. The peering is ACTIVE when there's a matching configuration in the peer network. |
| state\_details | Details about the current state of the peering. |