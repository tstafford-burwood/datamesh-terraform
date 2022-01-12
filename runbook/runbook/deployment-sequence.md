# SRDE project deployment sequence

Repo: terraform-gcp-greenfield
Branch: gcp-wcm-srde

Prerequisite: Build the terraform-validator container (run /cloudbuild/deployments/cloudbuild-terraform-validator-container.yaml)

1. Update the Constants directory (i.e. /environment/deployments/wcm-srde/constants) 
   1. /environment/deployments/wcm-srde/constants/constants.tf
   2. Save and commit to Git
2. Update /environment/foundation/vpc-service-controls/cloudbuild-access-levels/terraform.tfvars
3. Apply /environment/foundation/vpc-service-controls/cloudbuild-access-levels/main.tf
4. Update /environment/foundation/vpc-service-controls/srde-admin-access-levels/terraform.tfvars
5. Apply /environment/foundation/vpc-service-controls/srde-admin-access-levels/main.tf
6. Manually create the SRDE boot-strapping 'TF apply' pipeline (i.e. /environment/deployments/wcm-srde/cloudbuild-iam-and-pipelines/main.tf)
7. Update TF vars (environment/deployments/wcm-srde/cloudbuild-iam-and-pipelines/terraform.tfvars) and then run the new pipeline 
8. Update /environment/deployments/wcm-srde/packer-project/terraform.tfvars
9. Apply /environment/deployments/wcm-srde/packer-project/main.tf
10. Go to GCP Marketplace and create a RHEL CIS Level 2 VM
11. Create a GCP image from that VM
12. Run the packer-container pipeline (to create the Packer container image)
    1. DockerFile: /environment/deployments/wcm-srde/packer-project/packer-container/Dockerfile
13. Update the Packer .json files
    1.  /environment/deployments/wcm-srde/packer-project/researcher-vm-image-build/packer-rhel-cis-image.json
        1.  source_image (if name of base CIS image changes)
    2.  /environment/deployments/wcm-srde/packer-project/researcher-vm-image-build/packer-deep-learning-image.json
        1.  source_image
14. Run the Packer build pipelines (should have been set up in step 7)
    1.  /cloudbuild/deployments/cloudbuild-packer-rhel-cis-image.yaml
    2.  /cloudbuild/deployments/cloudbuild-packer-deep-learning-image.yaml
    3.  /cloudbuild/deployments/cloudbuild-pathml-container.yaml
        1.  Dockerfile: /environment/deployments/wcm-srde/packer-project/pathml-container/Dockerfile
15. 


