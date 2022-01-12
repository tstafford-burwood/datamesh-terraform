# Directory to Provision SRDE Folder Policies

This directory is used to provision Organizational policies on a folder within your organization. Projects that are inside the defined folder will inherit policies that are applied to the folder. A comprehensive list of additional organizational policies that can be used are described [here](https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints).

**NOTE** 
For any organizational policies where the `policy_type = list` and an `allow` list is being used will need to have `enforce = null` which defaults to a value of `true`. If `enforce` is set to `true` instead this can cause your state file to have tainted resources.

For a `policy_type = boolean` it is possible to use either `true` or `false` since there is no `allow` field.

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

## Examples

### Adding a New Policy

Below is an example of how to add a new policy that uses a boolean `policy_type`. Add this into the `main.tf`.

To mention again from the note above; for any organizational policies where the `policy_type = list` and an `allow` list is being used will need to have `enforce = null` which defaults to a value of `true`. If `enforce` is set to `true` instead this can cause your state file to have tainted resources.

For a `policy_type = boolean` it is possible to use either `true` or `false` since there is no `allow` field.

```terraform
module "<MODULE NAME>" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  constraint        = "constraints/<GCP_CONSTRAINT>"
  policy_type       = "boolean"
  policy_for        = "folder"
  folder_id         = var.srde_folder_id
  enforce           = <boolean value>
  exclude_folders   = []
  exclude_projects  = []
}
```

### Domain Restricted Sharing

For the `domain restricted sharing` constraint run the following gcloud command `gcloud organizations describe ORGANIZATION_ID`. This will output a `directoryCustomerId` which is used in the `domain restricted sharing` constraint.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.65.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 3.65.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_constants"></a> [constants](#module\_constants) | ../constants | n/a |
| <a name="module_srde_folder_define_trusted_image_projects"></a> [srde\_folder\_define\_trusted\_image\_projects](#module\_srde\_folder\_define\_trusted\_image\_projects) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_disable_automatic_iam_for_default_sa"></a> [srde\_folder\_disable\_automatic\_iam\_for\_default\_sa](#module\_srde\_folder\_disable\_automatic\_iam\_for\_default\_sa) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_disable_sa_creation"></a> [srde\_folder\_disable\_sa\_creation](#module\_srde\_folder\_disable\_sa\_creation) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_disable_sa_key_creation"></a> [srde\_folder\_disable\_sa\_key\_creation](#module\_srde\_folder\_disable\_sa\_key\_creation) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_disable_vm_nested_virtualization"></a> [srde\_folder\_disable\_vm\_nested\_virtualization](#module\_srde\_folder\_disable\_vm\_nested\_virtualization) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_domain_restricted_sharing"></a> [srde\_folder\_domain\_restricted\_sharing](#module\_srde\_folder\_domain\_restricted\_sharing) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_enforce_public_access_prevention"></a> [srde\_folder\_enforce\_public\_access\_prevention](#module\_srde\_folder\_enforce\_public\_access\_prevention) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_enforce_uniform_bucket_level_access"></a> [srde\_folder\_enforce\_uniform\_bucket\_level\_access](#module\_srde\_folder\_enforce\_uniform\_bucket\_level\_access) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_resource_location_restriction"></a> [srde\_folder\_resource\_location\_restriction](#module\_srde\_folder\_resource\_location\_restriction) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_restrict_public_ip_cloud_sql"></a> [srde\_folder\_restrict\_public\_ip\_cloud\_sql](#module\_srde\_folder\_restrict\_public\_ip\_cloud\_sql) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_restrict_shared_vpc_subnetwork"></a> [srde\_folder\_restrict\_shared\_vpc\_subnetwork](#module\_srde\_folder\_restrict\_shared\_vpc\_subnetwork) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_shielded_vms"></a> [srde\_folder\_shielded\_vms](#module\_srde\_folder\_shielded\_vms) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_skip_default_network_creation"></a> [srde\_folder\_skip\_default\_network\_creation](#module\_srde\_folder\_skip\_default\_network\_creation) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_vm_allowed_external_ip"></a> [srde\_folder\_vm\_allowed\_external\_ip](#module\_srde\_folder\_vm\_allowed\_external\_ip) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_vm_allowed_ip_forwarding"></a> [srde\_folder\_vm\_allowed\_ip\_forwarding](#module\_srde\_folder\_vm\_allowed\_ip\_forwarding) | terraform-google-modules/org-policy/google | ~> 3.0.2 |
| <a name="module_srde_folder_vm_os_login"></a> [srde\_folder\_vm\_os\_login](#module\_srde\_folder\_vm\_os\_login) | terraform-google-modules/org-policy/google | ~> 3.0.2 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_srde_folder_define_trusted_image_projects"></a> [srde\_folder\_define\_trusted\_image\_projects](#input\_srde\_folder\_define\_trusted\_image\_projects) | This list constraint defines the set of projects that can be used for image storage and disk instantiation for Compute Engine. The allowed/denied list of publisher projects must be strings in the form: projects/PROJECT\_ID. If this constraint is active, only images from trusted projects will be allowed as the source for boot disks for new instances. | `list(string)` | `[]` | no |
| <a name="input_srde_folder_disable_public_access_prevention_projects"></a> [srde\_folder\_disable\_public\_access\_prevention\_projects](#input\_srde\_folder\_disable\_public\_access\_prevention\_projects) | Define projects where GCS buckets can be opened to public access for allUsers or allAuthenticatedUsers. | `list(string)` | `[]` | no |
| <a name="input_srde_folder_domain_restricted_sharing_allow"></a> [srde\_folder\_domain\_restricted\_sharing\_allow](#input\_srde\_folder\_domain\_restricted\_sharing\_allow) | This list constraint defines the set of members that can be added to Cloud IAM policies in the SRDE folder. | `list(string)` | `[]` | no |
| <a name="input_srde_folder_resource_location_restriction_allow"></a> [srde\_folder\_resource\_location\_restriction\_allow](#input\_srde\_folder\_resource\_location\_restriction\_allow) | This list constraint defines the set of locations where location-based GCP resources can be created in for the SRDE folder. | `list(string)` | `[]` | no |
| <a name="input_srde_folder_restrict_shared_vpc_subnetwork_allow"></a> [srde\_folder\_restrict\_shared\_vpc\_subnetwork\_allow](#input\_srde\_folder\_restrict\_shared\_vpc\_subnetwork\_allow) | This list constraint defines the set of shared VPC subnetworks that eligible resources can use. The allowed/denied list of subnetworks must be specified in the form: under:organizations/ORGANIZATION\_ID, under:folders/FOLDER\_ID, under:projects/PROJECT\_ID, or projects/PROJECT\_ID/regions/REGION/subnetworks/SUBNETWORK-NAME. | `list(string)` | `[]` | no |
| <a name="input_srde_folder_vms_allowed_external_ip"></a> [srde\_folder\_vms\_allowed\_external\_ip](#input\_srde\_folder\_vms\_allowed\_external\_ip) | This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT\_ID/zones/ZONE/instances/INSTANCE | `list(string)` | `[]` | no |
| <a name="input_srde_folder_vms_allowed_ip_forwarding"></a> [srde\_folder\_vms\_allowed\_ip\_forwarding](#input\_srde\_folder\_vms\_allowed\_ip\_forwarding) | Identify VM instance name in format : projects/PROJECT\_ID, or projects/PROJECT\_ID/zones/ZONE/instances/INSTANCE-NAME. | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->