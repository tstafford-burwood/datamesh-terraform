# Terraform Directory for Packer Project

The purpose of this directory is to provision a standalone project that will store a Packer container image in Google Container Registry (GCR). This container image is then used to run the Packer application. This project will also maintain VM images that will be used with researcher workspace VMs.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.65.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 3.65.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 3.65.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_constants"></a> [constants](#module\_constants) | ../constants | n/a |
| <a name="module_packer-project"></a> [packer-project](#module\_packer-project) | ../../../../modules/project_factory | n/a |
| <a name="module_packer_container_artifact_registry_repository"></a> [packer\_container\_artifact\_registry\_repository](#module\_packer\_container\_artifact\_registry\_repository) | ../../../../modules/artifact_registry | n/a |
| <a name="module_packer_project_disable_sa_creation"></a> [packer\_project\_disable\_sa\_creation](#module\_packer\_project\_disable\_sa\_creation) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_packer_vpc"></a> [packer\_vpc](#module\_packer\_vpc) | ../../../../modules/vpc | n/a |
| <a name="module_path_ml_container_artifact_registry_repository"></a> [path\_ml\_container\_artifact\_registry\_repository](#module\_path\_ml\_container\_artifact\_registry\_repository) | ../../../../modules/artifact_registry | n/a |
| <a name="module_project_iam_marketplace_role"></a> [project\_iam\_marketplace\_role](#module\_project\_iam\_marketplace\_role) | ../../../../modules/iam/project_iam | n/a |
| <a name="module_terraform_validator_container_artifact_registry_repository"></a> [terraform\_validator\_container\_artifact\_registry\_repository](#module\_terraform\_validator\_container\_artifact\_registry\_repository) | ../../../../modules/artifact_registry | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.compute_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.enable_packer_project_apis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_storage_bucket.cloudbuild_gcs_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [time_sleep.wait_120_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activate_apis"></a> [activate\_apis](#input\_activate\_apis) | The list of apis to activate within the project | `list(string)` | <pre>[<br>  "compute.googleapis.com"<br>]</pre> | no |
| <a name="input_auto_create_network"></a> [auto\_create\_network](#input\_auto\_create\_network) | Create the default network | `bool` | `true` | no |
| <a name="input_auto_create_subnetworks"></a> [auto\_create\_subnetworks](#input\_auto\_create\_subnetworks) | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| <a name="input_bucket_force_destroy"></a> [bucket\_force\_destroy](#input\_bucket\_force\_destroy) | When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run. | `bool` | `false` | no |
| <a name="input_bucket_location"></a> [bucket\_location](#input\_bucket\_location) | Bucket location. See this link for regional and multi-regional options https://cloud.google.com/storage/docs/locations#legacy | `string` | `"US"` | no |
| <a name="input_bucket_storage_class"></a> [bucket\_storage\_class](#input\_bucket\_storage\_class) | Bucket storage class. Supported values include: STANDARD, MULTI\_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE. | `string` | `"STANDARD"` | no |
| <a name="input_create_project_sa"></a> [create\_project\_sa](#input\_create\_project\_sa) | Whether the default service account for the project shall be created | `bool` | `true` | no |
| <a name="input_default_service_account"></a> [default\_service\_account](#input\_default\_service\_account) | Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`. | `string` | `"keep"` | no |
| <a name="input_delete_default_internet_gateway_routes"></a> [delete\_default\_internet\_gateway\_routes](#input\_delete\_default\_internet\_gateway\_routes) | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `false` | no |
| <a name="input_deploymentmanager_editor"></a> [deploymentmanager\_editor](#input\_deploymentmanager\_editor) | Accounts with Deployment Manager role. | `string` | n/a | yes |
| <a name="input_disable_dependent_services"></a> [disable\_dependent\_services](#input\_disable\_dependent\_services) | Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. | `bool` | `true` | no |
| <a name="input_disable_services_on_destroy"></a> [disable\_services\_on\_destroy](#input\_disable\_services\_on\_destroy) | Whether project services will be disabled when the resources are destroyed | `string` | `"true"` | no |
| <a name="input_enforce_packer_project_disable_sa_creation"></a> [enforce\_packer\_project\_disable\_sa\_creation](#input\_enforce\_packer\_project\_disable\_sa\_creation) | Define variable to disable and enable policy at the project level during provisioning. | `bool` | `true` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | List of firewall rules | `any` | `[]` | no |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | A Google group to control the project by being assigned group\_role (defaults to project viewer) | `string` | `""` | no |
| <a name="input_group_role"></a> [group\_role](#input\_group\_role) | The role to give the controlling group (group\_name) over the project (defaults to project viewer) | `string` | `"roles/viewer"` | no |
| <a name="input_lien"></a> [lien](#input\_lien) | Add a lien on the project to prevent accidental deletion | `bool` | `false` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically. | `number` | n/a | yes |
| <a name="input_packer_container_artifact_repository_description"></a> [packer\_container\_artifact\_repository\_description](#input\_packer\_container\_artifact\_repository\_description) | The user-provided description of the repository. | `string` | `"Artifact Registry Repository created with Terraform."` | no |
| <a name="input_packer_container_artifact_repository_format"></a> [packer\_container\_artifact\_repository\_format](#input\_packer\_container\_artifact\_repository\_format) | The format of packages that are stored in the repository. You can only create alpha formats if you are a member of the [alpha user group](https://cloud.google.com/artifact-registry/docs/supported-formats#alpha-access). DOCKER, MAVEN (Preview), NPM (Preview), PYTHON (Preview), APT (alpha), YUM (alpha). | `string` | `""` | no |
| <a name="input_packer_container_artifact_repository_labels"></a> [packer\_container\_artifact\_repository\_labels](#input\_packer\_container\_artifact\_repository\_labels) | Labels with user-defined metadata. This field may contain up to 64 entries. Label keys and values may be no longer than 63 characters. Label keys must begin with a lowercase letter and may only contain lowercase letters, numeric characters, underscores, and dashes. | `map(string)` | `{}` | no |
| <a name="input_packer_container_artifact_repository_location"></a> [packer\_container\_artifact\_repository\_location](#input\_packer\_container\_artifact\_repository\_location) | The name of the location this repository is located in. | `string` | `""` | no |
| <a name="input_packer_container_artifact_repository_name"></a> [packer\_container\_artifact\_repository\_name](#input\_packer\_container\_artifact\_repository\_name) | The name of the repository that will be provisioned. | `string` | `""` | no |
| <a name="input_packer_project_iam_roles"></a> [packer\_project\_iam\_roles](#input\_packer\_project\_iam\_roles) | The IAM role(s) to assign to the member at the defined project. | `list(string)` | <pre>[<br>  "roles/deploymentmanager.editor",<br>  "roles/artifactregistry.admin",<br>  "roles/compute.admin"<br>]</pre> | no |
| <a name="input_path_ml_container_artifact_repository_description"></a> [path\_ml\_container\_artifact\_repository\_description](#input\_path\_ml\_container\_artifact\_repository\_description) | The user-provided description of the repository. | `string` | `"Artifact Registry Repository created with Terraform."` | no |
| <a name="input_path_ml_container_artifact_repository_format"></a> [path\_ml\_container\_artifact\_repository\_format](#input\_path\_ml\_container\_artifact\_repository\_format) | The format of packages that are stored in the repository. You can only create alpha formats if you are a member of the [alpha user group](https://cloud.google.com/artifact-registry/docs/supported-formats#alpha-access). DOCKER, MAVEN (Preview), NPM (Preview), PYTHON (Preview), APT (alpha), YUM (alpha). | `string` | `""` | no |
| <a name="input_path_ml_container_artifact_repository_labels"></a> [path\_ml\_container\_artifact\_repository\_labels](#input\_path\_ml\_container\_artifact\_repository\_labels) | Labels with user-defined metadata. This field may contain up to 64 entries. Label keys and values may be no longer than 63 characters. Label keys must begin with a lowercase letter and may only contain lowercase letters, numeric characters, underscores, and dashes. | `map(string)` | `{}` | no |
| <a name="input_path_ml_container_artifact_repository_location"></a> [path\_ml\_container\_artifact\_repository\_location](#input\_path\_ml\_container\_artifact\_repository\_location) | The name of the location this repository is located in. | `string` | `""` | no |
| <a name="input_path_ml_container_artifact_repository_name"></a> [path\_ml\_container\_artifact\_repository\_name](#input\_path\_ml\_container\_artifact\_repository\_name) | The name of the repository that will be provisioned. | `string` | `""` | no |
| <a name="input_project_labels"></a> [project\_labels](#input\_project\_labels) | Map of labels for project | `map(string)` | `{}` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name for the project | `string` | `""` | no |
| <a name="input_random_project_id"></a> [random\_project\_id](#input\_random\_project\_id) | Adds a suffix of 4 random characters to the `project_id` | `bool` | `true` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | List of routes being created in this VPC. For more information see [link](https://github.com/terraform-google-modules/terraform-google-network#route-inputs) | `list(map(string))` | `[]` | no |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | The network routing mode for regional dynamic routing or global dynamic routing (default 'GLOBAL' otherwise use 'REGIONAL') | `string` | `"GLOBAL"` | no |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| <a name="input_shared_vpc_host"></a> [shared\_vpc\_host](#input\_shared\_vpc\_host) | Makes this project a Shared VPC host if 'true' (default 'false') | `bool` | `false` | no |
| <a name="input_storage_bucket_labels"></a> [storage\_bucket\_labels](#input\_storage\_bucket\_labels) | Labels to be attached to the buckets | `map` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The list of subnets being created | `list(map(string))` | `[]` | no |
| <a name="input_terraform_validator_container_artifact_repository_description"></a> [terraform\_validator\_container\_artifact\_repository\_description](#input\_terraform\_validator\_container\_artifact\_repository\_description) | The user-provided description of the repository. | `string` | `"Artifact Registry Repository created with Terraform."` | no |
| <a name="input_terraform_validator_container_artifact_repository_format"></a> [terraform\_validator\_container\_artifact\_repository\_format](#input\_terraform\_validator\_container\_artifact\_repository\_format) | The format of packages that are stored in the repository. You can only create alpha formats if you are a member of the [alpha user group](https://cloud.google.com/artifact-registry/docs/supported-formats#alpha-access). DOCKER, MAVEN (Preview), NPM (Preview), PYTHON (Preview), APT (alpha), YUM (alpha). | `string` | `""` | no |
| <a name="input_terraform_validator_container_artifact_repository_labels"></a> [terraform\_validator\_container\_artifact\_repository\_labels](#input\_terraform\_validator\_container\_artifact\_repository\_labels) | Labels with user-defined metadata. This field may contain up to 64 entries. Label keys and values may be no longer than 63 characters. Label keys must begin with a lowercase letter and may only contain lowercase letters, numeric characters, underscores, and dashes. | `map(string)` | `{}` | no |
| <a name="input_terraform_validator_container_artifact_repository_location"></a> [terraform\_validator\_container\_artifact\_repository\_location](#input\_terraform\_validator\_container\_artifact\_repository\_location) | The name of the location this repository is located in. | `string` | `""` | no |
| <a name="input_terraform_validator_container_artifact_repository_name"></a> [terraform\_validator\_container\_artifact\_repository\_name](#input\_terraform\_validator\_container\_artifact\_repository\_name) | The name of the repository that will be provisioned. | `string` | `""` | no |
| <a name="input_uniform_bucket_level_access"></a> [uniform\_bucket\_level\_access](#input\_uniform\_bucket\_level\_access) | Enables Uniform bucket-level access access to a bucket. | `bool` | `false` | no |
| <a name="input_vpc_description"></a> [vpc\_description](#input\_vpc\_description) | An optional description of this resource. The resource must be recreated to modify this field. | `string` | `"VPC created from Terraform for web app use case deployment."` | no |
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | The name of the network being created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_enabled_apis"></a> [enabled\_apis](#output\_enabled\_apis) | Enabled APIs in the project |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The URI of the VPC being created |
| <a name="output_packer_container_artifact_repo_id"></a> [packer\_container\_artifact\_repo\_id](#output\_packer\_container\_artifact\_repo\_id) | An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository\_id}}. |
| <a name="output_packer_container_artifact_repo_name"></a> [packer\_container\_artifact\_repo\_name](#output\_packer\_container\_artifact\_repo\_name) | The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1` |
| <a name="output_path_ml_container_artifact_repo_id"></a> [path\_ml\_container\_artifact\_repo\_id](#output\_path\_ml\_container\_artifact\_repo\_id) | An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository\_id}}. |
| <a name="output_path_ml_container_artifact_repo_name"></a> [path\_ml\_container\_artifact\_repo\_name](#output\_path\_ml\_container\_artifact\_repo\_name) | The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1` |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | n/a |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | n/a |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | n/a |
| <a name="output_route_names"></a> [route\_names](#output\_route\_names) | The routes associated with this VPC. |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | The email of the default service account |
| <a name="output_subnets_names"></a> [subnets\_names](#output\_subnets\_names) | The names of the subnets being created |
| <a name="output_subnets_self_links"></a> [subnets\_self\_links](#output\_subnets\_self\_links) | The self-links of subnets being created |
| <a name="output_terraform_validator_container_artifact_repo_id"></a> [terraform\_validator\_container\_artifact\_repo\_id](#output\_terraform\_validator\_container\_artifact\_repo\_id) | An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository\_id}}. |
| <a name="output_terraform_validator_container_artifact_repo_name"></a> [terraform\_validator\_container\_artifact\_repo\_name](#output\_terraform\_validator\_container\_artifact\_repo\_name) | The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1` |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->