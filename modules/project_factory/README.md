# Terraform Module for Project Factory

This Terraform Module is used to provision a single project within GCP.

## Usage

Below is an example of how to use this module.

```terraform
module "project-factory" {
  source  = "./modules/project_factory"

  // REQUIRED FIELDS
  name            = "<PROJECT_ID>"
  org_id          = "<ORG_ID>"
  billing_account = "<BILLING_ACCOUNT>"
  folder_id       = "<FOLDER_ID>"

  // OPTIONAL FIELDS
  activate_apis               = ["compute.googleapis.com"]
  auto_create_network         = false
  group_name                  = "google_group@yourdomain.com"
  group_role                  = "role/viewer"
  labels                      = var.project_labels
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| project-factory | terraform-google-modules/project-factory/google | ~> 10.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activate\_apis | The list of apis to activate within the project | `list(string)` | <pre>[<br>  "compute.googleapis.com"<br>]</pre> | no |
| auto\_create\_network | Create the default network | `bool` | `false` | no |
| billing\_account\_id | The ID of the billing account to associate this project with | `string` | `""` | no |
| create\_project\_sa | Whether the default service account for the project shall be created | `bool` | `true` | no |
| default\_service\_account | Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`. | `string` | `"delete"` | no |
| disable\_dependent\_services | Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. | `bool` | `true` | no |
| disable\_services\_on\_destroy | Whether project services will be disabled when the resources are destroyed | `string` | `"true"` | no |
| folder\_id | The ID of a folder to host this project | `string` | `""` | no |
| group\_name | A Google group to control the project by being assigned group\_role (defaults to project viewer) | `string` | `""` | no |
| group\_role | The role to give the controlling group (group\_name) over the project (defaults to project viewer) | `string` | `"roles/viewer"` | no |        
| lien | Add a lien on the project to prevent accidental deletion | `bool` | `false` | no |
| org\_id | The organization ID. | `string` | `""` | no |
| project\_labels | Map of labels for project | `map(string)` | `{}` | no |
| project\_name | The name for the project | `string` | `""` | no |
| random\_project\_id | Adds a suffix of 4 random characters to the `project_id` | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| enabled\_apis | Enabled APIs in the project |
| project\_id | n/a |
| project\_name | n/a |