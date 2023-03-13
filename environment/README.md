# Getting Started

**Pre-Requirements <u>NOT</u> part of this build** 

1. GCP Project with Cloud Build must be established (Not part of this code base).
1. Cloud Build Service Account must have appropriate IAM roles
    - List IAM roles here
1. Cloud Build Service Account must have appropriate VPC Service Controls Permissions
    - Describe how to delegate the CB service account down to a particular folder.
    - Note, during Burwood's build, admins should have same permissions during build workshops.

## Code Folder Structure

The SDE is split into two main functions: `Foundation` and `Deployments`

* `Foundation` contains the IaC code for setting up the folder heirarchy, Cloud Build trigger, and core projects.
* `Development` contains the IaC code for setting up projects for researchers and to share data externally.

<!-- 
One of the objectives is to provide a lightweight reference design for the IaC repositories, and a built-in implementation for running this code in automated pipelines. This codeset utilizes an existing project with Cloud Build already connected to the desired GitHub repository. This configuration is outside of the document, but the setup can be found [here](https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github).



## Pre-requirements

To deploy this in your organization you will need

* a folder or organization where new projects will be created
* a billing account that will be associated with new projects
* an existing project with Cloud Build api enabled

## CI/CD
 -->

<!-- ### Bootstrap

To deploy the workflow configuration file a new temporary Cloud Build file needs to be created:

```bash
gcloud beta builds triggers create github \
--name="bootstrap-triggers-prod-apply" \
--repo-name="terraform-google-burwood-sde-prod" \
--repo-owner="client-it" \
--branch-pattern="^main$" \
--build-config="cloudbuild/foundation/cloudbuild-sde-apply.yaml"
--substitutions _BUCKET=<bucket_id>,_PREFIX=foundation,_TAG=1.2.1
```
* `_BUCKET` is the GCS bucket name that will store the Terraform tfstate files
* `_PREFIX` is the initial folder name in the GCS bucket
* `_TAG` is the Terraform version. -->

## Boostrap

### Pre-requirements

The admin deploying the SDE needs to have the following IAM roles:

**Organization Level**
* `roles/billing.Administrator` - To assign the Cloud Build service account to the billing account
* `roles/AccessContextAdmin` - To assign Access Context VPC Service Control delegation
* `roles/folders.Admin` - To create a top level folder. Default name is `SDE`.

**Cloud Build Project Level**
* `roles/Owner`

### Deploy Bootstrap

This bootstrap is used to help configure an <u>existing Cloud Build</u> service.

1. Clone the repo into your local environment and navigate to the `environments/bootstrap` directory. ```cd .\environment\bootstrap\```
1. Update the necessary values in the `variables.tf` file.
1. Run ```terraform init```, ```terraform plan```, ```terraform apply```.
    1. Capture the `sde_folder_id`, `terraform_state_bucket` from the outputs.
1. Manually connect the GITHUB repo to Cloud Build.
1. Run the bootstrap trigger
    1. Manually: Click [HERE](https://console.cloud.google.com/cloud-build/triggers?_ga=2.19577400.1279332550.1678733761-964487985.1650941830&_gac=1.12577478.1678733765.Cj0KCQjwk7ugBhDIARIsAGuvgPbbxpOamuWrxgAJXGno4zq2QAWtNgIH7xCR9Lc_WT8ZHcxTmiWVLsYaAvR_EALw_wcB)
    1. Enter command: ```gcloud beta builds triggers run bootstrap-trigger --project=<PROJECT_ID>```


## Deploying Foundation with Cloud Build

This IaC code contained under [Foundation](./foundation/) contains several distinct Terraform projects, each within their own directory that must be applied separately, but in sequence. Each of these Terraform projects are to be layered on top of each other, and must be ran in order.

### Create a GCS Bucket for Terraform State

Terraform needs a place to store its state. The common location is in the project that hosts the Cloud Build API.

Create a GCS bucket now that will be referenced in later steps.

### Create a Bootstrap Trigger

To help with this sequence, a [Cloud Build workflow configuration file](./cloudbuild/foundation/workflow-foundation-apply.yaml) has been developed to provision the environment in the appropriate sequence.

But, in order to use the [workflow config file](./cloudbuild/foundation/workflow-foundation-apply.yaml), you must create a temporary Bootstrap trigger. Below are the steps:

1. Clone the repo into your local environment and navigate to the `folders` directory. ```cd .\environment\foundation\folders\```
1. Create a temporary cloud build trigger called `bootstrap-triggers-prod-apply` to create the cloud build triggers.
   ```bash
    gcloud beta builds triggers create github \
    --name="bootstrap-triggers-prod-apply" \
    --repo-name="terraform-google-sde" \
    --repo-owner="OWNER" \
    --branch-pattern="^main$" \
    --build-config="cloudbuild/foundation/cloudbuild-sde-apply.yaml"
    --substitutions _BUCKET=<bucket_id>,_PREFIX=foundation,_TAG=1.2.1
    ``` 
    * `_BUCKET` is the GCS bucket name that will store the Terraform tfstate files
    * `_PREFIX` is the initial folder name in the GCS bucket
    * `_TAG` is the Terraform version.
1. Update the necessary files:
    1. Update the constants.tf file
    1. Update the cloudbuild sde [variables.tf](./foundation/cloudbuild-sde/variables.tf) file with GITHUB Owner and Repository info.
    1. Update the folders/env/terraform.tfvars file
    1. Grant Cloud Build SA `folder admin` and `project creator` to the parent folder. Grant Cloud Build SA `Org Policy Admin` at the org level. Grant Cloud Build SA `billing user` on billing account.
1. Manually set the trigger to disabled, and then run the trigger.
    >**Note:** you will see new triggers. These triggers monitor changes to any of the *.tfvar files under `Foundation`.

1. Push changes into the Git repository. The `workflow` pipeline will see the change and kick-off.
1. Destroy the trigger named `bootstrap-triggers-prod-apply`.

## Deploying Deployments with Cloud Build

The code contained under the [Deployment](./deployments/researcher-projects/) must be deployed separately, but in sequence. To help with this sequence workflow, a separate pipeline has been developed. The [Foundation](##Deploying-Foundation-with-Cloud-Build) steps above autoamtically create the necessary [researcher tenant triggers](../cloudbuild/foundation/workflow-foundation-apply.yaml#L37) for each initiative.


<!-- To know more about this directory and its structure go [here](./deployments/researcher-projects/). -->

### Example

In this example, we're going to create a new researcher initative called `Project-Z`.

1. `cd ./environment/foundation/folder/env/`
1. Edit the `terraform.tfvars` file with the following values:
    ```diff
    - researcher_workspace_folders = ["workspace-1"]
    + researcher_workspace_folders = ["workspace-1", "Project-Z"]
    ```
    > Note: The values given here are used to create the folder names, but are also used at the index value for downstream values. Be sure to name accordingly.
1. `git add . -f`, `git commit -m "New researcher folder"`, `git push`
1. The `sde-workflow-foundation-apply` will be triggered and run.
    > A new trigger in Cloud Build will be created for `Project-Z`.
1. Copy the template directory to a new directory. `cd ./environment/deployments/researcher-projects/env/`, `cp -R template/ Project-Z/`, `cd Project-Z`
    >Note: The directory name **MUST** match the value name given in the variable `researcher_workspace_folders`.
1. Update the `*.tfvar` files.
    1. **global.tfvars** `researcher_workspace_name` must match the folder name given above.
    
        ```diff
        - researcher_workspace_name = "rare-disease"
        - lbl_department            = "phi" 
        + researcher_workspace_name = "Project-Z"
        + lbl_department            = "pci" 
        ```
        - `researcher_workspace_name` is used as the flag to deploy projects into        
    1. **egress/terraform.tfvars** `project_users`
        ```git
        - project_users = ["user:user1@example.com"] 
        + project_users = ["user:user@client.edu"] 
        ```
    1. **workspace/terraform.tfvars** `researchers`
        ```git
        - researchers = ["user:user1@example.com"]  
        + researchers = ["user:user@client.edu"]  
        ```
1. `git add .`, `git commit -m "New researcher init"`, `git push`
1. The Cloud Build trigger associated with `Project-Z` will be triggered and ran.




<!-- Follow the steps below to deploy a new Secure Data Enclave:

1. Update all the necessary .tfvar files.
1. In Cloud Build connect to the Git repository.
1. Create a cloud build trigger to the create cloud build triggers
1. Kick off this new trigger.
1. Push in your code changes -->

<!-- ## Initial Bootstrap of a Researcher Iniative Project

New Researcher Iniatives are provisioned by creating a new folder under the Deployments/env directory and updating the *.tfvar files. Once the updated *.tfvar files are pushed into the Git repository, a Cloud Build pipeline will see the changes and be triggered. Below are those steps:

1. Create a new `researcher_workspace_folder`. Perform a git add ., git commit -m "New workspace", git push.
    ```bash
    cd ./deployments/researcher-projects/env/
    cp template 
    ```
1. In the TF code hierarchy, create a new folder for researchers. This folder name must match the `researcher_workspace_folder` value above.
1. Update the egress.tfvars, global.tfvars, workspace.tfvars
    1. **Note:** workspace.tfvars the `num_instances` must be zero. VPC-SC fails if `num_instances` is > 0.
1. Push in your code changes with a git add . , git commit -m "New researcher init", git push.

##  -->