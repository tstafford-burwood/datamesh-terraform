# Directory to Provision a Cloud Composer Environment

The purpose of this directory is to provision a Cloud Composer environment that is fully managed by GCP. Cloud Composer is a resource that allows for data orchestration workflows to be used. Primarily this will be used to take data from the staging project and move it to a researcher's workspace GCS ingress bucket.

This directory does not need to be updated when new research groups are onboarded into the SRDE. The purpose of this directory is to only maintain the Cloud Composer instance.

## General Usage

1. From a best practice approach a new branch should generally be created from the `master` or `main` branch when working on new features or updates.
    1. Run `git checkout -b <BRANCH_NAME>`
1. Change into the desired directory that needs to have infrastructure code updated.
1. Edit either the `main.tf`, `variables.tf`, or `terraform.tfvars` file, depending on what needs to be updated.
1. If there are variables which are needed but not present in the `.tfvars` file those can be added and updated as needed.
1. In order to limit any auto-approved changes being made to your infrastructure there are two options.
    1. If you want to merge back into master you can edit out any `apply` steps within the Cloud Build YAML file that this pipeline is associated to so that only an `init` and `plan` are ran to show what the potential Terraform changes will do.
    1. If you are working out of a feature branch you can create a new Cloud Build trigger to monitor the feature branch, create a new Cloud Build YAML with only an `init` and `plan` step, then verify that the `plan` output is good to proceed forward with.
1. Save your files, `git add <files>`, `git commit -m "<MESSAGE>"`, `git push`.
1. If you were working out of a feature branch you can merge back into `master`.
    1. `git checkout <master or main>`, `git merge <FEATURE_BRANCH> --no-ff`
1. A manual pipeline run may need to be started after a merge is done if no edits have been done on the `included_files` after the merge. These are generally the `.tfvars` files which are monitored for changes to start the pipeline.

## Initial Cloud Composer Setup Guide

1. After the Cloud Composer environment is provisioned any user that accesses the environment will have an `Admin` role. 
1. This will need to be changed so that Data Stewards can only run DAGs that are relevant to their research group.
1. Navigate to the Cloud Composer resource.
1. Click the name of the Composer resource and navigate to the `Airflow Configuration Overrides` tab.
1. Select `Edit` and add:
    1. Section of `webserver`.
    1. Key of `rbac_user_registration_role`.
    1. Value of `Public`.
1. Save changes.
1. This can additionally be updated in the `.tfvars` file but needs to be done after the environment is provisioned so that at least one user has the `Admin` role.
1. The tfvar to edit is `airflow_config_overrides` and the value to pass in is `"webserver-rbac_user_registration_role" = "True"`.
1. The Composer environment in GCP will take some time to update.
1. After the environment is back navigate to the Airflow webserver UI.
1. Navigate to the `Admin` tab and select `Configurations`.
1. Ensure that the `[webserver]` section contains `rbac_user_registration_role = Public`.
1. Navigate to the `Security` tab and select `List Users` and ensure only one user is listed in there with the `[Admin]` role. If there are multiple Admins their records can be deleted on this page.

## Creating Cloud Composer Roles for RBAC

1. Each research group will need a role within Cloud Composer so that RBAC can be enforced.
1. Navigate to the `Security` tab and select `List Roles`.
1. Select the `+` icon to create a new role/record.
1. Name the role based on the name of the DAG that was created for that group. This is just the full workspace project ID.
1. An example is `group1-srde-workspace-428e`. This value will also show in the DAGs that were created for each group.
1. The permissions to add will follow a naming scheme of:
    1. `Can dag edit <WORKSPACE_PROJECT_ID> <UNIQUE_DAG_NAME>` for each group.
    1. `Can dag read <WORKSPACE_PROJECT_ID> <UNIQUE_DAG_NAME>` for each group.
    1. In total there are 5 DAGs per naming scheme for a total of 10 permissions that will need to be added.
1. This role will then need to be assigned to a Data Steward that is a part of the desired research group.
1. The Data Steward should log in to have a user entry populated for them.
1. Navigate to the `Security` tab and `List Users`.
1. Navigate to the Data Steward's username and edit their record.
1. Update the `Role` field with the newly created role.
1. Ensure that the user only has `Public` and the new group role to read and edit DAGs.
1. Save changes.

## Optional tfvar Fields to Configure

1. In the `.tfvars` file of this directory there are some optional fields that can be configured to customize the security of the Cloud Composer instance.
1. `airflow_config_overrides` can be used to enable Role Based Access Control on the instance.
1. `allowed_ip_range` can be used to only allow users to access the Airflow webserver UI if their request originates from a certain CIDR range.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.65.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 3.65.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_composer"></a> [cloud\_composer](#module\_cloud\_composer) | ../../../../../modules/cloud_composer | n/a |
| <a name="module_cloud_composer_access_level_members"></a> [cloud\_composer\_access\_level\_members](#module\_cloud\_composer\_access\_level\_members) | ../../../../../modules/vpc_service_controls/access_levels | n/a |
| <a name="module_composer_service_account"></a> [composer\_service\_account](#module\_composer\_service\_account) | ../../../../../modules/service_account | n/a |
| <a name="module_constants"></a> [constants](#module\_constants) | ../../constants | n/a |
| <a name="module_folder_iam_member"></a> [folder\_iam\_member](#module\_folder\_iam\_member) | ../../../../../modules/iam/folder_iam | n/a |
| <a name="module_staging_project_disable_sa_creation"></a> [staging\_project\_disable\_sa\_creation](#module\_staging\_project\_disable\_sa\_creation) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_staging_project_shielded_vms"></a> [staging\_project\_shielded\_vms](#module\_staging\_project\_shielded\_vms) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_staging_project_vm_os_login"></a> [staging\_project\_vm\_os\_login](#module\_staging\_project\_vm\_os\_login) | terraform-google-modules/org-policy/google | ~> 3.0.2 |

## Resources

| Name | Type |
|------|------|
| [time_sleep.wait_120_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_level_description"></a> [access\_level\_description](#input\_access\_level\_description) | Description of the access level. | `string` | `""` | no |
| <a name="input_access_level_members"></a> [access\_level\_members](#input\_access\_level\_members) | Condition - An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid} | `list(string)` | `[]` | no |
| <a name="input_access_level_name"></a> [access\_level\_name](#input\_access\_level\_name) | Description of the AccessLevel and its use. Does not affect behavior. | `string` | `""` | no |
| <a name="input_airflow_config_overrides"></a> [airflow\_config\_overrides](#input\_airflow\_config\_overrides) | Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example "core-dags\_are\_paused\_at\_creation". | `map(string)` | `{}` | no |
| <a name="input_allowed_device_management_levels"></a> [allowed\_device\_management\_levels](#input\_allowed\_device\_management\_levels) | Condition - A list of allowed device management levels. An empty list allows all management levels. | `list(string)` | `[]` | no |
| <a name="input_allowed_encryption_statuses"></a> [allowed\_encryption\_statuses](#input\_allowed\_encryption\_statuses) | Condition - A list of allowed encryption statuses. An empty list allows all statuses. | `list(string)` | `[]` | no |
| <a name="input_allowed_ip_range"></a> [allowed\_ip\_range](#input\_allowed\_ip\_range) | The IP ranges which are allowed to access the Apache Airflow Web Server UI. | <pre>list(object({<br>    value       = string<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | The ID of the billing account to associate this project with | `string` | `""` | no |
| <a name="input_cloud_sql_ipv4_cidr"></a> [cloud\_sql\_ipv4\_cidr](#input\_cloud\_sql\_ipv4\_cidr) | The CIDR block from which IP range in tenant project will be reserved for Cloud SQL. | `string` | `null` | no |
| <a name="input_combining_function"></a> [combining\_function](#input\_combining\_function) | How the conditions list should be combined to determine if a request is granted this AccessLevel. If AND is used, each Condition must be satisfied for the AccessLevel to be applied. If OR is used, at least one Condition must be satisfied for the AccessLevel to be applied. | `string` | `"AND"` | no |
| <a name="input_composer_env_name"></a> [composer\_env\_name](#input\_composer\_env\_name) | Name of Cloud Composer Environment | `string` | n/a | yes |
| <a name="input_composer_service_account"></a> [composer\_service\_account](#input\_composer\_service\_account) | Service Account for running Cloud Composer. | `string` | `null` | no |
| <a name="input_database_machine_type"></a> [database\_machine\_type](#input\_database\_machine\_type) | The machine type to setup for the SQL database in the Cloud Composer environment. | `string` | `"db-n1-standard-2"` | no |
| <a name="input_description"></a> [description](#input\_description) | Descriptions of the created service accounts (defaults to no description) | `string` | `""` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The disk size in GB for nodes. | `string` | `"50"` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display names of the created service accounts (defaults to 'Terraform-managed service account') | `string` | `"Terraform-managed service account"` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Configure the ability to have public access to the cluster endpoint. If private endpoint is enabled, connecting to the cluster will need to be done with a VM in the same VPC and region as the Composer environment. Additional details can be found [here](https://cloud.google.com/composer/docs/concepts/private-ip#cluster). | `bool` | `false` | no |
| <a name="input_enforce_staging_project_disable_sa_creation"></a> [enforce\_staging\_project\_disable\_sa\_creation](#input\_enforce\_staging\_project\_disable\_sa\_creation) | Define variable to disable and enable policy at the project level during provisioning. | `bool` | `true` | no |
| <a name="input_enforce_staging_project_shielded_vms"></a> [enforce\_staging\_project\_shielded\_vms](#input\_enforce\_staging\_project\_shielded\_vms) | Define variable to disable and enable policy at the project level during provisioning. | `bool` | `true` | no |
| <a name="input_enforce_staging_project_vm_os_login"></a> [enforce\_staging\_project\_vm\_os\_login](#input\_enforce\_staging\_project\_vm\_os\_login) | Define variable to disable and enable policy at the project level during provisioning. | `bool` | `true` | no |
| <a name="input_env_variables"></a> [env\_variables](#input\_env\_variables) | Variables of the airflow environment. | `map(string)` | `{}` | no |
| <a name="input_generate_keys"></a> [generate\_keys](#input\_generate\_keys) | Generate keys for service accounts. | `bool` | `false` | no |
| <a name="input_gke_machine_type"></a> [gke\_machine\_type](#input\_gke\_machine\_type) | Machine type of Cloud Composer nodes. | `string` | `"n1-standard-8"` | no |
| <a name="input_grant_billing_role"></a> [grant\_billing\_role](#input\_grant\_billing\_role) | Grant billing user role. | `bool` | `false` | no |
| <a name="input_grant_xpn_roles"></a> [grant\_xpn\_roles](#input\_grant\_xpn\_roles) | Grant roles for shared VPC management. | `bool` | `false` | no |
| <a name="input_iam_role_list"></a> [iam\_role\_list](#input\_iam\_role\_list) | The IAM role(s) to assign to the member at the defined folder. | `list(string)` | `[]` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The version of Airflow running in the Cloud Composer environment. | `string` | `null` | no |
| <a name="input_ip_subnetworks"></a> [ip\_subnetworks](#input\_ip\_subnetworks) | Condition - A list of CIDR block IP subnetwork specifications. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, "192.0.2.0/24" is accepted but "192.0.2.1/24" is not. Similarly, for IPv6, "2001:db8::/32" is accepted whereas "2001:db8::1/32" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed. | `list(string)` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The resource labels (a map of key/value pairs) to be applied to the Cloud Composer. | `map(string)` | `{}` | no |
| <a name="input_master_ipv4_cidr"></a> [master\_ipv4\_cidr](#input\_master\_ipv4\_cidr) | The CIDR block from which IP range in tenant project will be reserved for the master. | `string` | `null` | no |
| <a name="input_minimum_version"></a> [minimum\_version](#input\_minimum\_version) | The minimum allowed OS version. If not set, any version of this OS satisfies the constraint. Format: "major.minor.patch" such as "10.5.301", "9.2.1". | `string` | `""` | no |
| <a name="input_negate"></a> [negate](#input\_negate) | Whether to negate the Condition. If true, the Condition becomes a NAND over its non-empty fields, each field must be false for the Condition overall to be satisfied. | `bool` | `false` | no |
| <a name="input_network"></a> [network](#input\_network) | The VPC network to host the Composer cluster. | `string` | n/a | yes |
| <a name="input_network_project_id"></a> [network\_project\_id](#input\_network\_project\_id) | The project ID of the shared VPC's host (for shared vpc support) | `string` | `""` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Number of worker nodes in the Cloud Composer Environment. | `number` | `3` | no |
| <a name="input_oauth_scopes"></a> [oauth\_scopes](#input\_oauth\_scopes) | Google API scopes to be made available on all node. | `set(string)` | <pre>[<br>  "https://www.googleapis.com/auth/cloud-platform"<br>]</pre> | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | The organization ID. | `string` | `""` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | The operating system type of the device. | `string` | `"OS_UNSPECIFIED"` | no |
| <a name="input_pod_ip_allocation_range_name"></a> [pod\_ip\_allocation\_range\_name](#input\_pod\_ip\_allocation\_range\_name) | The name of the cluster's secondary range used to allocate IP addresses to pods. | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service account names. | `string` | `""` | no |
| <a name="input_project_roles"></a> [project\_roles](#input\_project\_roles) | Common roles to apply to all service accounts, project=>role as elements. | `list(string)` | `[]` | no |
| <a name="input_pypi_packages"></a> [pypi\_packages](#input\_pypi\_packages) | Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. "numpy"). | `map(string)` | `{}` | no |
| <a name="input_python_version"></a> [python\_version](#input\_python\_version) | The default version of Python used to run the Airflow scheduler, worker, and webserver processes. | `string` | `"3"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the Cloud Composer Environment is created. | `string` | `"us-central1"` | no |
| <a name="input_regions"></a> [regions](#input\_regions) | Condition - The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code. | `list(string)` | `[]` | no |
| <a name="input_require_corp_owned"></a> [require\_corp\_owned](#input\_require\_corp\_owned) | Condition - Whether the device needs to be corp owned. | `bool` | `false` | no |
| <a name="input_require_screen_lock"></a> [require\_screen\_lock](#input\_require\_screen\_lock) | Condition - Whether or not screenlock is required for the DevicePolicy to be true. | `bool` | `false` | no |
| <a name="input_required_access_levels"></a> [required\_access\_levels](#input\_required\_access\_levels) | Condition - A list of other access levels defined in the same Policy, referenced by resource name. Referencing an AccessLevel which does not exist is an error. All access levels listed must be granted for the Condition to be true. | `list(string)` | `[]` | no |
| <a name="input_service_account_names"></a> [service\_account\_names](#input\_service\_account\_names) | Names of the service accounts to create. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_service_ip_allocation_range_name"></a> [service\_ip\_allocation\_range\_name](#input\_service\_ip\_allocation\_range\_name) | The name of the services' secondary range used to allocate IP addresses to the cluster. | `string` | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The subnetwork to host the Composer cluster. | `string` | n/a | yes |
| <a name="input_subnetwork_region"></a> [subnetwork\_region](#input\_subnetwork\_region) | The subnetwork region of the shared VPC's host (for shared vpc support) | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls. | `set(string)` | `[]` | no |
| <a name="input_use_ip_aliases"></a> [use\_ip\_aliases](#input\_use\_ip\_aliases) | Enable Alias IPs in the GKE cluster. If true, a VPC-native cluster is created. | `bool` | `false` | no |
| <a name="input_web_server_ipv4_cidr"></a> [web\_server\_ipv4\_cidr](#input\_web\_server\_ipv4\_cidr) | The CIDR block from which IP range in tenant project will be reserved for the web server. | `string` | `null` | no |
| <a name="input_web_server_machine_type"></a> [web\_server\_machine\_type](#input\_web\_server\_machine\_type) | The machine type to setup for the Apache Airflow Web Server UI. | `string` | `"composer-n1-webserver-2"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone where the Cloud Composer nodes are created. | `string` | `"us-central1-f"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_composer_env_id"></a> [composer\_env\_id](#output\_composer\_env\_id) | ID of Cloud Composer Environment. |
| <a name="output_composer_env_name"></a> [composer\_env\_name](#output\_composer\_env\_name) | Name of the Cloud Composer Environment. |
| <a name="output_email"></a> [email](#output\_email) | The service account email. |
| <a name="output_gcs_bucket"></a> [gcs\_bucket](#output\_gcs\_bucket) | Google Cloud Storage bucket which hosts DAGs for the Cloud Composer Environment. |
| <a name="output_gke_cluster"></a> [gke\_cluster](#output\_gke\_cluster) | Google Kubernetes Engine cluster used to run the Cloud Composer Environment. |
| <a name="output_iam_email"></a> [iam\_email](#output\_iam\_email) | The service account IAM-format email. |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Service account resource (for single use). |
| <a name="output_service_accounts"></a> [service\_accounts](#output\_service\_accounts) | Service account resources as list. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->