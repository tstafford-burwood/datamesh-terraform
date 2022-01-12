# Terraform Module for Google Cloud Storage Bucket

This module is used to provision a Google Cloud Storage Bucket in GCP.

## Usage

Below is an example of how to use this module.

```terraform
module "gcs_buckets" {
  source                        = "./gcs_bucket"
  version                       = "~> 1.7.0"
  project_id                    = "<PROJECT_ID>"
  names                         = ["first", "second"]
  bucket_prefix_name            = "my-unique-prefix"
  bucket_set_admin_roles        = true
  admins                        = ["group:foo-admins@example.com"]
  bucket_versioning             = { first = true }
  bucket_admins                 = { second = "user:spam@example.com,eggs@example.com" }
}
```

## Note

If the module is used as is the bucket name will concatenate with two sets of 4 random hex digits in the name. For example `storage-bucket-name-1234-5678`. This will introduce additional uniqueness to your bucket name. 

If the extra digits are not needed you can set `names = var.bucket_suffix_name` instead of having it as `names = formatlist("%v-%v", var.bucket_suffix_name, random_id.bucket_suffix_addition.hex)` in the `main.tf` that is being used to provision this resource. Do not directly edit `.\modules\gcs_bucket\main.tf`.

## Providers

| Name | Version |
|------|---------|
| random | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| gcs_bucket | terraform-google-modules/cloud-storage/google | ~> 1.7.0 |

## Resources

| Name |
|------|
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admins | IAM-style members who will be granted role/storage.objectAdmins for all buckets. | `list(string)` | `[]` | no |
| bucket\_encryption\_key\_names | Optional map of lowercase unprefixed name => string, empty strings are ignored. | `map` | `{}` | no |
| bucket\_folders | Map of lowercase unprefixed name => list of top level folder objects. | `map` | `{}` | no |
| bucket\_force\_destroy | Optional map of lowercase unprefixed name => boolean, defaults to false. | `map` | `{}` | no |
| bucket\_location | Bucket location. See this link for regional and multi-regional options https://cloud.google.com/storage/docs/locations#legacy | `string` | `"US"` | no |
| bucket\_prefix\_name | The prefix/beginning used to generate the bucket. | `string` | n/a | yes |
| bucket\_set\_admin\_roles | Grant roles/storage.objectAdmin role to admins and bucket\_admins. | `bool` | `false` | no |
| bucket\_set\_creator\_roles | Grant roles/storage.objectCreator role to creators and bucket\_creators. | `bool` | `false` | no |
| bucket\_set\_viewer\_roles | Grant roles/storage.objectViewer role to viewers and bucket\_viewers. | `bool` | `false` | no |
| bucket\_storage\_class | Bucket storage class. Supported values include: STANDARD, MULTI\_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE. | `string` | `"STANDARD"` | no |
| bucket\_suffix\_name | The suffix/ending name for the bucket. | `list(string)` | n/a | yes |
| bucket\_versioning | Optional map of lowercase unprefixed name => boolean, defaults to false. | `map` | `{}` | no |
| creators | IAM-style members who will be granted roles/storage.objectCreators on all buckets. | `list(string)` | `[]` | no |
| project\_id | Bucket project id. | `string` | n/a | yes |
| storage\_bucket\_labels | Labels to be attached to the buckets | `map` | `{}` | no |
| viewers | IAM-style members who will be granted roles/storage.objectViewer on all buckets. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket | Bucket resource (for single use). |
| bucket\_name | Bucket name (for single use). |
| buckets | Bucket resources as list. |
| names | Bucket names. |
| names\_list | List of bucket names. |