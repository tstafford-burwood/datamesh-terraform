# Directory Structure

```
(top-folder)
└── cloudbuild
└── environment
    └── deployments
    └── foundation
        └── ...
└── modules
    ├── project_factory
    └── vpc
        ├── main.tf
        ├── variables.tf
        └── ...
```

## Modules Directory

The `modules` directory is where the blueprints are stored for resources that will be provisioned through a `main.tf` file.

## Deployments Directory

In the `deployments` directory, each environment (workspace) is defined with reference to the set of modules that make up the environment. Typically, these can be a copy-and-paste with some slight differences, like changing project name or labels.

## Usage

To create new modules reference the [../runbook/create-modules.md](../runbook/create-modules.md).

To provision modules using the `deployment` directory, reference either the [../runbook/new-application-deployment.md] or the [../runbook/deployed-project-maintenance.md](../runbook/deployed-project-maintenance.md)