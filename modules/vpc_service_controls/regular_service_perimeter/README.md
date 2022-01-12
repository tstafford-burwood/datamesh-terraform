# Terraform Module for Provisioning a VPC Service Control Regular Perimeter

The purpose of this directory is to provision a regular VPC Service Control perimeter around a project or group of projects. The use of a VPC Service Control perimeter allows for APIs to be restricted and access can only be granted to users or service accounts to restricted APIs if they have Access Levels. Without an Access Level a user or service account cannot make API calls if those APIs are restricted in the perimeter.

## Usage

Below is an example of how to use this module.

`gcloud organizations list` is used to gather the Organization ID
`gcloud access-context-manager policies list --organization=<ORG_ID>` is used to gather the `parent_policy_name` field


```terraform
module "regular_service_perimeter" {
  source = "./modules/vpc_service_controls/regular_service_perimeter"

  // REQUIRED
  regular_service_perimeter_description = "My Regular Perimeter Description"
  regular_service_perimeter_name        = "my_regular_perimeter_name"
  parent_policy_id                      = "0123456789"

  // OPTIONAL
  access_level_names          = ["access_level_name_here"]
  project_to_add_perimeter    = ["<PROJECT_NUMBER>"]
  restricted_services         = ["storage.googleapis.com"]
  enable_restriction          = true
  allowed_services            = []
}
```

## Providers

| Name | Version |
|------|---------|
| google | n/a |


## Resources

| Name |
|------|
| [google_access_context_manager_service_perimeter](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/access_context_manager_service_perimeter) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_level\_names | A list of Access Level resource names that allow resources within the Service Perimeter to be accessed from the internet. Access Levels listed must be in the same policy as this Service Perimeter. Referencing a nonexistent Access Level is a syntax error. If no Access Level names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY\_POLICY/accessLevels/MY\_LEVEL'. For Service Perimeter Bridge, must be empty. | `list(string)` | `[]` | no |
| allowed\_services | The list of APIs usable within the Service Perimeter from a VPC network within the perimeter. Must be empty unless 'enable\_restriction' is True. | `list(string)` | `[]` | no |
| enable\_restriction | Whether to restrict API calls within the Service Perimeter to the list of APIs specified in 'allowed\_services'. This can be useful if only certain APIs should be allowed to be accessed from a network within the VPC service control perimeter. | `bool` | `false` | no |
| parent\_policy\_id | ID of the parent policy | `string` | `""` | no |
| project\_to\_add\_perimeter | A list of GCP resources (only projects) that are inside of the service perimeter. Currently only projects are allowed. | `list(string)` | `[]` | no |
| regular\_service\_perimeter\_description | Description of the regular perimeter | `string` | `""` | no |
| regular\_service\_perimeter\_name | Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores | `string` | `""` | no |
| restricted\_services | GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions. | `list(string)` | `[]` | no |      

## Outputs

| Name | Description |
|------|-------------|
| regular\_service\_perimeter\_name | The perimeter's name. |
| regular\_service\_perimeter\_resources | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. |
| vpc\_accessible\_services | The API services accessible from a network within the VPC SC perimeter. |