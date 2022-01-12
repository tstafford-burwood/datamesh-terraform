# Terraform Module for Provisioning Access Levels

The purpose of this directory is to provision Access Levels which are applied to VPC Service Control Perimeters as a "firewall" type filter. Access Levels are not equivalent to VPC firewalls but can be thought of as accomplishing a similar function. 

If a user or service account has an Access Level assigned to them and that Access Level is allowed on a VPC Service Control perimeter then that user or service account is granted access to restricted APIs within that project. 

Restricted APIs are declared when a VPC Service Control Perimeter is provisioned. Additional IAM roles may be required for a user or service account to perform functions. 

An Access Level does not directly grant a user or service account the permissions needed to see storage buckets in the GCS resource. To list the storage buckets a user or service account would need the permission `storage.buckets.list`. In order to make the API call for `storage.googleapis.com` in a restricted VPC Service Control perimeter the user or service account would need an Access Level.

As an example if a user in Cloud Shell were to run `gsutil ls` in a project that has a VPC Service Control perimeter and has `storage.googleapis.com` as a restricted API that user would first need an Access Level to make the API call and also would need `storage.buckets.list` as a minimum permission inside a role to list out the buckets on their terminal.

Additional information on Access Levels can be found [here](https://cloud.google.com/access-context-manager/docs/overview#access-levels).

## Usage

Below is an example of how to use this module.

`gcloud organizations list` is used to gather the Organization ID
`gcloud access-context-manager policies list --organization=<ORG_ID>` is used to gather the `parent_policy_name` field

```terraform
module "access_level_members" {
  source = "./modules/vpc_service_controls/access_levels"

  // REQUIRED
  access_level_name  = "my_access_level"
  parent_policy_name = "0123456789"

  // OPTIONAL - NON PREMIUM
  combining_function       = "OR"
  access_level_description = "my_access_level_description"
  ip_subnetworks           = ["X.X.X.X/X"]
  access_level_members     = ["user:username@domain.com"]
  negate                   = false
  regions                  = ["us-east4"]
  required_access_levels   = var.required_access_levels
}
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| access_level_members | terraform-google-modules/vpc-service-controls/google//modules/access_level | 3.0.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_level\_description | Description of the access level. | `string` | `""` | no |
| access\_level\_members | Condition - An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid} | `list(string)` | `[]` | no |
| access\_level\_name | Description of the AccessLevel and its use. Does not affect behavior. | `string` | `""` | no |
| allowed\_device\_management\_levels | Condition - A list of allowed device management levels. An empty list allows all management levels. | `list(string)`| `[]` | no |
| allowed\_encryption\_statuses | Condition - A list of allowed encryption statuses. An empty list allows all statuses. | `list(string)` | `[]` | no |       
| combining\_function | How the conditions list should be combined to determine if a request is granted this AccessLevel. If AND is used, each Condition must be satisfied for the AccessLevel to be applied. If OR is used, at least one Condition must be satisfied for the AccessLevel to be applied. | `string` | `"AND"` | no |
| ip\_subnetworks | Condition - A list of CIDR block IP subnetwork specifications. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, "192.0.2.0/24" is accepted but "192.0.2.1/24" is not. Similarly, for IPv6, "2001:db8::/32" is accepted whereas "2001:db8::1/32" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed. | `list(string)` | `[]` | no |
| minimum\_version | The minimum allowed OS version. If not set, any version of this OS satisfies the constraint. Format: "major.minor.patch" such as "10.5.301", "9.2.1". | `string` | `""` | no |
| negate | Whether to negate the Condition. If true, the Condition becomes a NAND over its non-empty fields, each field must be false for the Condition overall to be satisfied. | `bool` | `false` | no |
| os\_type | The operating system type of the device. | `string` | `"OS_UNSPECIFIED"` | no |
| parent\_policy\_name | Name of the parent policy. | `string` | `""` | no |
| regions | Condition - The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code. | `list(string)` | `[]` | no |
| require\_corp\_owned | Condition - Whether the device needs to be corp owned. | `bool` | `false` | no |
| require\_screen\_lock | Condition - Whether or not screenlock is required for the DevicePolicy to be true. | `bool` | `false` | no |
| required\_access\_levels | Condition - A list of other access levels defined in the same Policy, referenced by resource name. Referencing an AccessLevel which does not exist is an error. All access levels listed must be granted for the Condition to be true. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | Description of the AccessLevel and its use. Does not affect behavior. |
| name\_id | The fully-qualified name of the Access Level. Format: accessPolicies/{policy\_id}/accessLevels/{name} |