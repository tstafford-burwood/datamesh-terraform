# Terraform Module for Provisioning Cloud Build Service Account IAM Roles

The purpose of this directory is to apply defined IAM roles to a Cloud Build Service Account at the folder level.

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

Below is an example of how to update the `.tfvars` file in order to update IAM roles for the Cloud Build Service account.

```diff
iam_role_list = [
  "roles/bigquery.dataOwner",
  "roles/cloudbuild.builds.builder",
  "roles/composer.environmentAndStorageObjectAdmin",
  "roles/compute.instanceAdmin.v1",
  "roles/compute.networkAdmin",
  "roles/iam.serviceAccountAdmin",
  "roles/iam.serviceAccountUser",
  "roles/pubsub.admin",
  "roles/resourcemanager.projectCreator",
  "roles/resourcemanager.projectIamAdmin",
  "roles/serviceusage.serviceUsageConsumer",
+ "roles/storage.admin",
+ "roles/pubsub.viewer"
]
```
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_constants"></a> [constants](#module\_constants) | ../constants | n/a |
| <a name="module_folder_iam_member"></a> [folder\_iam\_member](#module\_folder\_iam\_member) | ../../../../modules/iam/folder_iam | n/a |

## Resources

| Name | Type |
|------|------|
| [google_cloudbuild_trigger.deep_learning_vm_image_build](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.packer_container_image](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.path_ml_container_image](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.rhel_cis_image_build](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.srde_admin_access_level_apply](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.srde_admin_access_level_plan](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.srde_apply_triggers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.srde_cloudbuild_sa_access_level_apply](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.srde_cloudbuild_sa_access_level_plan](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.srde_composer_apply_trigger](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.srde_composer_plan_trigger](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.srde_plan_triggers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.terraform_validator_container_image](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_role_list"></a> [iam\_role\_list](#input\_iam\_role\_list) | The IAM role(s) to assign to the member at the defined folder. | `list(string)` | `[]` | no |
| <a name="input_srde_admin_access_level_apply_trigger_disabled"></a> [srde\_admin\_access\_level\_apply\_trigger\_disabled](#input\_srde\_admin\_access\_level\_apply\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_admin_access_level_apply_trigger_tags"></a> [srde\_admin\_access\_level\_apply\_trigger\_tags](#input\_srde\_admin\_access\_level\_apply\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_admin_access_level_plan_trigger_disabled"></a> [srde\_admin\_access\_level\_plan\_trigger\_disabled](#input\_srde\_admin\_access\_level\_plan\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_admin_access_level_plan_trigger_tags"></a> [srde\_admin\_access\_level\_plan\_trigger\_tags](#input\_srde\_admin\_access\_level\_plan\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_apply_branch_name"></a> [srde\_apply\_branch\_name](#input\_srde\_apply\_branch\_name) | Regex matching branches to build. Exactly one a of branch name, tag, or commit SHA must be provided. The syntax of the regular expressions accepted is the syntax accepted by RE2 and described at https://github.com/google/re2/wiki/Syntax | `string` | `""` | no |
| <a name="input_srde_apply_trigger_disabled"></a> [srde\_apply\_trigger\_disabled](#input\_srde\_apply\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_apply_trigger_filename"></a> [srde\_apply\_trigger\_filename](#input\_srde\_apply\_trigger\_filename) | Path, from the source root, to a file whose contents is used for the template. Either a filename or build template must be provided. | `string` | `""` | no |
| <a name="input_srde_apply_trigger_included_files"></a> [srde\_apply\_trigger\_included\_files](#input\_srde\_apply\_trigger\_included\_files) | ignoredFiles and includedFiles are file glob matches using https://golang.org/pkg/path/filepath/#Match extended with support for **. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is empty, then as far as this filter is concerned, we should trigger the build. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is not empty, then we make sure that at least one of those files matches a includedFiles glob. If not, then we do not trigger a build. | `string` | `""` | no |
| <a name="input_srde_apply_trigger_invert_regex"></a> [srde\_apply\_trigger\_invert\_regex](#input\_srde\_apply\_trigger\_invert\_regex) | Only trigger a build if the revision regex does NOT match the revision regex. | `bool` | `false` | no |
| <a name="input_srde_apply_trigger_name"></a> [srde\_apply\_trigger\_name](#input\_srde\_apply\_trigger\_name) | Name of the trigger. Must be unique within the project. | `list(string)` | `[]` | no |
| <a name="input_srde_apply_trigger_project_id"></a> [srde\_apply\_trigger\_project\_id](#input\_srde\_apply\_trigger\_project\_id) | The ID of the project in which the resource belongs and ID of the project that owns the Cloud Source Repository. If it is not provided, the provider project is used. | `string` | `""` | no |
| <a name="input_srde_apply_trigger_repo_name"></a> [srde\_apply\_trigger\_repo\_name](#input\_srde\_apply\_trigger\_repo\_name) | Name of the Cloud Source Repository. If omitted, the name `default` is assumed. | `string` | `""` | no |
| <a name="input_srde_apply_trigger_tags"></a> [srde\_apply\_trigger\_tags](#input\_srde\_apply\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_cloudbuild_sa_access_level_apply_trigger_disabled"></a> [srde\_cloudbuild\_sa\_access\_level\_apply\_trigger\_disabled](#input\_srde\_cloudbuild\_sa\_access\_level\_apply\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_cloudbuild_sa_access_level_apply_trigger_tags"></a> [srde\_cloudbuild\_sa\_access\_level\_apply\_trigger\_tags](#input\_srde\_cloudbuild\_sa\_access\_level\_apply\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_cloudbuild_sa_access_level_plan_trigger_disabled"></a> [srde\_cloudbuild\_sa\_access\_level\_plan\_trigger\_disabled](#input\_srde\_cloudbuild\_sa\_access\_level\_plan\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_cloudbuild_sa_access_level_plan_trigger_tags"></a> [srde\_cloudbuild\_sa\_access\_level\_plan\_trigger\_tags](#input\_srde\_cloudbuild\_sa\_access\_level\_plan\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_composer_apply_trigger_disabled"></a> [srde\_composer\_apply\_trigger\_disabled](#input\_srde\_composer\_apply\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_composer_apply_trigger_tags"></a> [srde\_composer\_apply\_trigger\_tags](#input\_srde\_composer\_apply\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_composer_dag_bucket"></a> [srde\_composer\_dag\_bucket](#input\_srde\_composer\_dag\_bucket) | The name of the Cloud Composer DAG bucket. This will be necessary for some pipelines and not all pipelines. This value is obtained after the Cloud Composer instance is provisioned since it is a GCP managed resource. | `string` | `""` | no |
| <a name="input_srde_composer_plan_trigger_disabled"></a> [srde\_composer\_plan\_trigger\_disabled](#input\_srde\_composer\_plan\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_composer_plan_trigger_tags"></a> [srde\_composer\_plan\_trigger\_tags](#input\_srde\_composer\_plan\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_deep_learning_vm_image_build_trigger_disabled"></a> [srde\_deep\_learning\_vm\_image\_build\_trigger\_disabled](#input\_srde\_deep\_learning\_vm\_image\_build\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_deep_learning_vm_image_build_trigger_tags"></a> [srde\_deep\_learning\_vm\_image\_build\_trigger\_tags](#input\_srde\_deep\_learning\_vm\_image\_build\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_packer_container_image_build_trigger_disabled"></a> [srde\_packer\_container\_image\_build\_trigger\_disabled](#input\_srde\_packer\_container\_image\_build\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_packer_container_image_build_trigger_tags"></a> [srde\_packer\_container\_image\_build\_trigger\_tags](#input\_srde\_packer\_container\_image\_build\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_packer_image_tag"></a> [srde\_packer\_image\_tag](#input\_srde\_packer\_image\_tag) | The container image tag of Packer that was provisioned. | `string` | `""` | no |
| <a name="input_srde_packer_project_id"></a> [srde\_packer\_project\_id](#input\_srde\_packer\_project\_id) | The ID of the Packer project after it is provisioned. | `string` | `""` | no |
| <a name="input_srde_path_ml_container_image_build_trigger_disabled"></a> [srde\_path\_ml\_container\_image\_build\_trigger\_disabled](#input\_srde\_path\_ml\_container\_image\_build\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_path_ml_container_image_build_trigger_tags"></a> [srde\_path\_ml\_container\_image\_build\_trigger\_tags](#input\_srde\_path\_ml\_container\_image\_build\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_plan_branch_name"></a> [srde\_plan\_branch\_name](#input\_srde\_plan\_branch\_name) | Regex matching branches to build. Exactly one a of branch name, tag, or commit SHA must be provided. The syntax of the regular expressions accepted is the syntax accepted by RE2 and described at https://github.com/google/re2/wiki/Syntax | `string` | `""` | no |
| <a name="input_srde_plan_trigger_disabled"></a> [srde\_plan\_trigger\_disabled](#input\_srde\_plan\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_plan_trigger_filename"></a> [srde\_plan\_trigger\_filename](#input\_srde\_plan\_trigger\_filename) | Path, from the source root, to a file whose contents is used for the template. Either a filename or build template must be provided. | `string` | `""` | no |
| <a name="input_srde_plan_trigger_included_files"></a> [srde\_plan\_trigger\_included\_files](#input\_srde\_plan\_trigger\_included\_files) | ignoredFiles and includedFiles are file glob matches using https://golang.org/pkg/path/filepath/#Match extended with support for **. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is empty, then as far as this filter is concerned, we should trigger the build. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is not empty, then we make sure that at least one of those files matches a includedFiles glob. If not, then we do not trigger a build. | `string` | `""` | no |
| <a name="input_srde_plan_trigger_invert_regex"></a> [srde\_plan\_trigger\_invert\_regex](#input\_srde\_plan\_trigger\_invert\_regex) | Only trigger a build if the revision regex does NOT match the revision regex. | `bool` | `false` | no |
| <a name="input_srde_plan_trigger_name"></a> [srde\_plan\_trigger\_name](#input\_srde\_plan\_trigger\_name) | Name of the trigger. Must be unique within the project. | `list(string)` | `[]` | no |
| <a name="input_srde_plan_trigger_project_id"></a> [srde\_plan\_trigger\_project\_id](#input\_srde\_plan\_trigger\_project\_id) | The ID of the project in which the resource belongs and ID of the project that owns the Cloud Source Repository. If it is not provided, the provider project is used. | `string` | `""` | no |
| <a name="input_srde_plan_trigger_repo_name"></a> [srde\_plan\_trigger\_repo\_name](#input\_srde\_plan\_trigger\_repo\_name) | Name of the Cloud Source Repository. If omitted, the name `default` is assumed. | `string` | `""` | no |
| <a name="input_srde_plan_trigger_tags"></a> [srde\_plan\_trigger\_tags](#input\_srde\_plan\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_rhel_cis_image_build_trigger_disabled"></a> [srde\_rhel\_cis\_image\_build\_trigger\_disabled](#input\_srde\_rhel\_cis\_image\_build\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_rhel_cis_image_build_trigger_tags"></a> [srde\_rhel\_cis\_image\_build\_trigger\_tags](#input\_srde\_rhel\_cis\_image\_build\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_srde_terraform_validator_container_image_build_trigger_disabled"></a> [srde\_terraform\_validator\_container\_image\_build\_trigger\_disabled](#input\_srde\_terraform\_validator\_container\_image\_build\_trigger\_disabled) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `bool` | `false` | no |
| <a name="input_srde_terraform_validator_container_image_build_trigger_tags"></a> [srde\_terraform\_validator\_container\_image\_build\_trigger\_tags](#input\_srde\_terraform\_validator\_container\_image\_build\_trigger\_tags) | Tags for annotation of a BuildTrigger | `list(string)` | `[]` | no |
| <a name="input_terraform_container_version"></a> [terraform\_container\_version](#input\_terraform\_container\_version) | The container version of Terraform to use with this pipeline during a Cloud Build build. | `string` | `""` | no |
| <a name="input_terraform_state_bucket"></a> [terraform\_state\_bucket](#input\_terraform\_state\_bucket) | The name of the state bucket where Terraform state will be stored. | `string` | `""` | no |
| <a name="input_terraform_state_prefix"></a> [terraform\_state\_prefix](#input\_terraform\_state\_prefix) | The name of the prefix to create in the state bucket. This will end up creating additional sub-directories to store state files in an orderly fashion. The additional sub-directories are generally created as a declaration inside of the Cloud Build YAML file of each pipeline. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->