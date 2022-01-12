# Deployments

The purpose of the `Deployments` directory is to deploy new projects and maintain previously provisioned projects.

## Deployments Directory Structure & Subdirectory Considerations

The `deployments` directory is setup in a way where each provisioned project is a uniquely named sub-directory.

As project provisioning needs increase a best practice approach is to continually create new projects for researchers/groups as new subdirectories within the `deployments` folder. A naming scheme such as `group1-app-use-case`, `group2-app-use-case`, etc. can be used to distinguish/isolate projects and Terraform files from one another.

## Cloudbuild Directory Structure & Subdirectory Considerations

The [cloudbuild/deployments directory](../../cloudbuild/deployments) is where all of the YAML files should be maintained for use-case projects. Ideally this will follow a similar naming scheme/directory structure to the `environment/deployments` directory mentioned above.

## Automation Pipelines

Cloud Build is used as a serverless CI/CD platform in GCP. Pipelines for projects under the `deployments` directory should be created and maintained within a centralized GCP project.

## Repository Setup
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