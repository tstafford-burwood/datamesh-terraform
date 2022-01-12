# Terraform Module for IAP Tunneling

The purpose of this module is to enable IAP tunneling within a project for a defined network. Instances can be declared where IAM role bindings for `roles/iap.tunnelResourceAccessor ` are applied directly to the VM. A firewall rule will be created that allows SSH connections on port 22 from a defined IAP IP CIDR of `35.235.240.0/20`.

## Usage

Below is an example of how to use this module.

module "iap_tunneling" {
  source  = "./modules/iap"

  // REQUIRED
  project                    = "project123"
  instances                  = [{
    name = "<GCE_INSTANCE_NAME>"
    zone = "<GCE_INSTANCE_ZONE>"
  }]
  members                    = [
    "group:devs@example.com",
    "user:me@example.com",
  ]
  network                    = var.network_self_link

  // OPTIONAL
  additional_ports           = var.additional_ports
  create_firewall_rule       = true
  fw_name_allow_ssh_from_iap = var.fw_name_allow_ssh_from_iap
  host_project               = "<NETWORK_PROJECT_ID>"
  network_tags               = ["network-tag-allow-iap"]  
}

## Modules

| Name | Source | Version |
|------|--------|---------|
| iap_tunneling | terraform-google-modules/bastion-host/google//modules/iap-tunneling | ~> 3.2.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_ports | A list of additional ports/ranges to open access to on the instances from IAP. | `list(string)` | `[]` | no |
| create\_firewall\_rule | If we need to create the firewall rule or not. | `bool` | `true` | no |
| fw\_name\_allow\_ssh\_from\_iap | Firewall rule name for allowing SSH from IAP. | `string` | `"allow-ssh-from-iap-to-tunnel"` | no |
| host\_project | The network host project ID. | `string` | `""` | no |
| iap\_members | List of IAM resources to allow using the IAP tunnel. | `list(string)` | `[]` | no |
| instances | Names and zones of the instances to allow SSH from IAP. | <pre>list(object({<br>    name = string<br>    zone = string<br>  }))</pre> | `[]` | no |
| network\_self\_link | Self link of the network to attach the firewall to. | `string` | n/a | yes |
| network\_tags | Network tags associated with the instances to allow SSH from IAP. Exactly one of service\_accounts or network\_tags should be specified. | `list(string)` | `[]` | no |
| project | The project ID to deploy to. | `string` | n/a | yes |

## Outputs

No output.