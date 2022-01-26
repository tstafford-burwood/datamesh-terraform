# Directory for Provisioning a Cloud Build Service Account Access Level

The purpose of this directory is to provision an access level for a Cloud Build Service Account. This service account is being used in a GCP project that has the Cloud Build API enabled. An access level can be thought of as a way to grant permission to a defined user/service account for accessing restricted services within a VPC Service Control perimeter. An example diagram is shown below to help visualize how an authorized IP address can be allowed access into a VPC Service Control perimeter.

![VPC_SC_Access_Level](../../../../runbook/images/vpc-sc-access-level.png)

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

## Example Code

Below is an example of how to update the `.tfvars` file for the Cloud Build Access Level.

```diff
    // REQUIRED TFVARS

-   access_level_name  = "cloudbuild_service_account"
+   access_level_name  = "<ACCESS_LEVEL_NAME_WITH_UNDERSCORES>"

    // OPTIONAL TFVARS - NON PREMIUM

-   combining_function       = "OR"
+   combining_function       = "AND"

-   access_level_description = "Cloudbuild Service Account Access Level for Terraform operations"
+   access_level_description = "<DESCRIPTION>"

-   ip_subnetworks           = []
+   ip_subnetworks           = [0.0.0.0/0]

-   access_level_members     = ["serviceAccount:<SERVICE_ACCOUNT_ADDRESS>"]
+   access_level_members     = ["serviceAccount:<SERVICE_ACCOUNT_ADDRESS>"]

    negate                   = false
    regions                  = []
    required_access_levels   = []
```
## Requirements

| Name | Version |
|------|---------|
| google | ~> 3.65.0 |     
| google-beta | ~> 3.65.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cloudbuild_access_level | ../../../../modules/vpc_service_controls/access_levels |  |
| constants | ../../../deployments/wcm-sde/constants |  |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_level\_description | Description of the access level. | `string` | `""` | no |
| access\_level\_members | Condition - An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid} | `list(string)` | `[]` | no |
| access\_level\_name | Description of the AccessLevel and its use. Does not affect behavior. | `string` | `""` | no |
| allowed\_device\_management\_levels | Condition - A list of allowed device management levels. An empty list allows all management levels. | `list(string)` | `[]` | no |
| allowed\_encryption\_statuses | Condition - A list of allowed encryption statuses. An empty list allows all statuses. | `list(string)` | `[]` | no 
|
| combining\_function | How the conditions list should be combined to determine if a request is granted this AccessLevel. If AND is used, each Condition must be satisfied for the AccessLevel to be applied. If OR is used, at least one Condition must be satisfied for the AccessLevel to be applied. | `string` | `"AND"` | no |
| ip\_subnetworks | Condition - A list of CIDR block IP subnetwork specifications. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, "192.0.2.0/24" is accepted but "192.0.2.1/24" is not. Similarly, for IPv6, "2001:db8::/32" is accepted whereas "2001:db8::1/32" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed. | `list(string)` | `[]` | no |
| minimum\_version | The minimum allowed OS version. If not set, any version of this OS satisfies the constraint. Format: "major.minor.patch" such as "10.5.301", "9.2.1". | `string` | `""` | no |
| negate | Whether to negate the Condition. If true, the Condition becomes a NAND over its non-empty fields, each field must be false for the Condition overall to be satisfied. | `bool` | `false` | no |
| os\_type | The operating system type of the device. | `string` | `"OS_UNSPECIFIED"` | no |
| regions | Condition - The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code. | `list(string)` | `[]` | no |
| require\_corp\_owned | Condition - Whether the device needs to be corp owned. | `bool` | `false` | no |
| require\_screen\_lock | Condition - Whether or not screenlock is required for the DevicePolicy to be true. | `bool` | `false` | no |
| required\_access\_levels | Condition - A list of other access levels defined in the same Policy, referenced by resource name. Referencing an AccessLevel which does not exist is an error. All access levels listed must be granted for the Condition to be true. | `list(string)` | `[]` | no |        

## Outputs

| Name | Description |
|------|-------------|
| name | Description of the AccessLevel and its use. Does not affect behavior. |
| name\_id | The fully-qualified name of the Access Level. Format: accessPolicies/{policy\_id}/accessLevels/{name} |