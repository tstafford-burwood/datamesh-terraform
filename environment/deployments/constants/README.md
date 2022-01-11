# Terraform Directory for Constant Values

The purpose of this directory is to declare constant values such as `org_id`, `billing_account_id`,`folder_id`, etc. This directory can then be imported into other directories as a `module` and values can be referenced in those other directories. This will help reduce the need to declare the same input repeatedly.

## Usage

This directory is not linked to a Cloud Build pipeline. 

1. Values can be updated here on an as-needed basis.
1. Save, commit, and push changes to a source repository.
1. If local values were changed and need to be propagated to pre-existing infrastructure then run those respective pipelines such as the `researcher-projects` or `secure-staging-project` directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_value"></a> [value](#output\_value) | Reference output for accessing locals values in this directory. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->