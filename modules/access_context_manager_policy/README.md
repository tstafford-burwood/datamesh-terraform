# Terraform Module for Access Context Manager Policy

An [Access Context Manager](https://cloud.google.com/access-context-manager/docs/overview) Policy allows organization administrators to create policies for fine-grained project and resource access control. This resource creates an AccessPolicy which acts as a container to store AccessLevels. This is provisioned only once at the organizational level.

## Usage

The variable `parent_id` is the Organization ID and can be retrieved through Cloud Shell with the command `gcloud organizations list`. The only other parameter to pass in is the `policy_name`.

Below is an example of how to use this code.

```terraform
module "google_access_context_manager_access_policy" {
  source      = "./modules/acess_context_manager_policy"
  parent_id   = "123456789"
  policy_name = "my_policy"
}
```

## Resources

| Name |
|------|
| [google_access_context_manager_access_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/access_context_manager_access_policy) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | `string` | n/a | yes |
| policy\_name | The policy's name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_id | Resource name of the AccessPolicy. |
| policy\_name | The policy's name. |