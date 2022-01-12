# Terraform GCP Foundation and Deployment

This code repository is intended to deploy a GCP project for the WCM SRDE initiative.

## Repository Structure

#### [cloudbuild](./cloudbuild)
The [cloudbuild](./cloudbuild) directory contains the Cloud Build YAML files and build steps used for Cloud Build triggers.

#### [deployments under the environment directory](./environment/deployments)
The [deployments](./environment/deployments) subdirectory located under the environment directory is used to deploy new projects along with maintaining any previously provisioned projects. The use of the deployments subdirectory is intended for an IT group to deploy projects for researchers and should not be used for Foundational/Organizational level maintenance.

#### [modules](./modules)
The [modules](./modules) directory stores blueprints of Terraform code. These modules are used to provision resources into GCP.

## Where to Begin

Most of the time, deployments are decentralized, meaning a project is created by an IT group and handed over to a PI or researcher to be used for their initiatives. Terraform may never be used again to manage the project, but it is used for consistency and repeatability.

In order to build new projects with new infrastructure, these components should be kept in the [modules](./modules) directory. A modules directory will enable IT groups to have re-usable, variable, and self-maintained code. The [environment/deployments](./environment/deployments) directory will be used to provision and maintain projects.