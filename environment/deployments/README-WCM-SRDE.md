# Directory for Provisioning Secure Research Data Environment (SRDE) Components

The purpose of this directory is to provision all necessary components of a Secure Research Data Environment (SRDE). This includes Cloud Build IAM roles, a project for Packer, individual researcher projects, a staging project with Cloud Composer, and Organizational policies that are applied at the folder level.

All researcher projects should be provisioned within the single SRDE directory. The folder `researcher-projects` can be duplicated and given a unique name to identify the research group or Principal Investigator (PI) that the project is being provisioned for. An additional SRDE directory underneath the deployments directory does not need to be deployed.

# SRDE Infrastructure

Below is an example of the resources which will be provisioned.

Some main components include:
*   A bastion project that allows researchers an entrypoint into the SRDE.
*   A workspace project that allows researchers to perform necessary research functions inside of.
*   A staging project that allows data stewards to upload secure data into. This project also contains an instance of Cloud Composer that is used to orchestrate data workflows. This will help to facilitate the movement of data into a researcher's workspace by use of a service account.
*   A packer project that is used to build custom GCE images for VMs to use.
*   VPC Service controls around all projects.
    *   The bastion, workspace, and staging project will have APIs that will be restricted.
*   A project used as an external collaboration platform where data that has passed DLP scans can be placed in. This will allow for external collaborators to access that data.

![](../../../runbook/images/gcp-srde-architecture-v1.png)