# Introduction

1. The [modules](../modules) directory in this repository contains pre-defined code that can be repeatedly used for new projects as their building blocks.
1. Modules can be thought of as highly opinionated blocks of code to declare what resource(s) need to be provisioned through Terraform.
1. Having a self-maintained directory of modules will allow for resources to be provisioned in a consistent manner and will allow your team to use similar code.

## Creating Terraform Modules

1. Create a subdirectory inside the [modules](../modules) directory for a new module.
1. Source code for modules can be used from a [Google maintained GitHub repository](https://github.com/terraform-google-modules) for Terraform or from the [Terraform GCP Registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs).
    1. Each sub-directory should contain a `main.tf`, `variables.tf`, and `outputs.tf`. There is not a need for a `.tfvars` in the modules directory.
    1. The `main.tf` will need to declare the module name, source, and version.
    1. Using the [google-project-factory](https://github.com/terraform-google-modules/terraform-google-project-factory) module as an example the fields below will need to be copied into the `main.tf`.

    <br>

    ```terraform
    module "project-factory" {
        source  = "terraform-google-modules/project-factory/google"
        version = "~> 10.1"
    ```
    1. There are certain required fields which can be determined by looking at the [Inputs](https://github.com/terraform-google-modules/terraform-google-project-factory#inputs) section of the README and scrolling to the `Required` column.
    1. In the example of the project-factory module an input such as `name` is a required field.
        1. Add `name` as an input field into the `main.tf` for the block of code listed above.

            ```diff
            module "project-factory" {
                source  = "terraform-google-modules/project-factory/google"
                version = "~> 10.1"

            +   name    = var.name
            ```
        1. Add a `name` variable into the `variables.tf` file.
            ```
            variable "name" {
            description = "The name for the project"
            type        = string
            }
            ```
        1. In the GitHub repository there is an `outputs.tf` file with outputs that can be used. If these are needed copy them as they are into your self-hosted module's `outputs.tf` file.
            1. In the above example the output for a project name would be:
                ```
                output "project_name" {
                value = module.project-factory.project_name
                }
                ```
        1. Continue this process for any other required variables.
        1. Non-required variables can also be added if they will be useful for provisioning resources based on your team's needs.