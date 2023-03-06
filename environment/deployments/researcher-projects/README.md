# Terraform Directory for Provisioning Tenants

## Guiding Principles

This directory is used when a researcher workspace or tenant, needs to be provisioned or updated. The end goal of this directory is to provision secured GCP projects that allows researchers to perform necessary work on protected data.

**Use folders for configurations**

Unlike the core [Foundation which uses Git branches](../../foundation/README.md) to separate configurations, the workspaces/tenants will use a folders structure to separate out environments which may not be exact copies of each other.

**Environments**

To re-use code, but have different environments the "workspace" comprises of two projects: [egress project](./egress/README.md) and [workspace project](./workspace/README.md). These Terraform templates are varaiblesed to allow for different inputs. The default inputs can be overrided with a [Terraform *.tfvars]() file which allow for different environments.

To be able to deploy multiple enivonments, a directory called [env](./env) is provided. This folder contains a top level folder that's named after the desired tenant name, and sub-folders which contain the [*.tfvars]() for each of the projects.

### Create new tenants

Follow the [New Tenant Readme](./new-tenant.md) for a detailed description on how to create a new workspace/tenant.

### Create new Application Integration

Click [here](./application-integration.md) for instructions.

## Overview

| Steps | Comments |
| --- | --- |
| Globals | No resources are deployed, only global values are configured|
| Egress | Deploys a project with a bucket to be shared with other researchers |
| Workspace | Deploys a project with a VM instance and tools for researchers |
| VPC SC | Create a VPC Service perimeter around the projects and VPC SC bridges to other foundation projects |


This directory contains several distinct Terraform modules and projects each within their own directory that must be applied separately, but in sequence. Each of these Terraform projects are to be layered on top of each other, running in the following order.

[globals](./env/template/globals.tfvars)

The contents in this directory are used to be shared across all of the researcher initiative projects. It will share core values like the Billing ID and the researcher_workspace_name.

[egress](./egress/)

The contents in this directory are used to create the researcher's egress project. The resources in this project are used to share out contents like a GCS bucket.

After executing this step, you will have the following structure:

```bash
.. fldr-HIPAA-{env}
|   ├── prj-images
|   ├── prj-data-ingress
|   ├── prj-data-lake
|   ├── prj-data-ops
|   └── fldr-workspace-1 (researcher initiative)
|        └── prj-egress
```

[workspace](./workspace/)

The contents in this directory are used to create the researcher's workspace project. The resources in this project are VM instances that researchers' will remote into. The tools will be pre-installed for the researcher. Other resources like GCS buckets for scratch space and backups will be configured.

After executing this step, you will have the following structure:

```bash
.. fldr-HIPAA-{env}
|   ├── prj-images
|   ├── prj-data-ingress
|   ├── prj-data-lake
|   ├── prj-data-ops
|   └── fldr-workspace-1 (researcher initiative)
|        ├── prj-egress
|        └── prj-wrkspce
```

[vpc-sc](./vpc-sc/)

The contents in this directory creates a VPC Service Control perimeter and puts the `egress` and `workspace` projects inside of the perimeter. Additional bridges are built so connectivity is established between the researcher projects and the foundation projects.