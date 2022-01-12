#----------------------------------------------------------------------------
# PACKER PROJECT TFVARS
#----------------------------------------------------------------------------

// OPTIONAL TFVARS
activate_apis = [
  "cloudbuild.googleapis.com",
  "artifactregistry.googleapis.com",
  "deploymentmanager.googleapis.com",
  "runtimeconfig.googleapis.com",
  "oslogin.googleapis.com",
  "compute.googleapis.com"
]
auto_create_network         = false
create_project_sa           = false
default_service_account     = "keep"
disable_dependent_services  = true
disable_services_on_destroy = true
group_name                  = ""
group_role                  = ""

project_labels = {
  "srde" : "packer-project"
}

lien              = false
random_project_id = true

#----------------------------------------------------------------------------
# GCS BUCKET MODULE TFVARS
#----------------------------------------------------------------------------

// GCS BUCKET TFVARS - OPTIONAL
bucket_location             = "us-central1"
uniform_bucket_level_access = true

#----------------------------------------------------------------------------
# PACKER VPC TFVARS
# The `subnet_name` is hard coded in some of the cloudbuild files like
# cloudbuild-packer-deep-learning-image.yaml.
# Change this value, other files will need to be updated.
#----------------------------------------------------------------------------

vpc_network_name        = "packer-vpc"
auto_create_subnetworks = false
firewall_rules          = []
routing_mode            = "GLOBAL"
mtu                     = 1460

subnets = [
  {
    subnet_name               = "packer-us-central1-subnet" // CHANGE NAME, OTHER FILES MUST BE UPDATED
    subnet_ip                 = "10.0.0.0/24"
    subnet_region             = "us-central1"
    subnet_flow_logs          = "true"
    subnet_flow_logs_interval = "INTERVAL_10_MIN"
    subnet_flow_logs_sampling = 0.7
    subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    subnet_private_access     = "true"
  }
]

#----------------------------------------------------------------------------
# PACKER CONTAINER ARTIFACT REGISTRY REPOSITORY TFVARS
# The cloudbuild/deployments/cloudbuild-packer-container.yaml has the region
# hard coded. If region changes here, must change there.
#----------------------------------------------------------------------------

packer_container_artifact_repository_name        = "packer"
packer_container_artifact_repository_format      = "DOCKER"
packer_container_artifact_repository_description = "Packer Container Artifact Registry Repository created with Terraform"
packer_container_artifact_repository_labels      = { "repository" : "packer-container" }

#----------------------------------------------------------------------------
# terraform-validator CONTAINER ARTIFACT REGISTRY REPOSITORY TFVARS
# The cloudbuild/deployments/cloudbuild-terraform-validator.yaml has the region
# hard coded. If region changes here, must change there.
#----------------------------------------------------------------------------

terraform_validator_container_artifact_repository_name        = "terraform-validator"
terraform_validator_container_artifact_repository_format      = "DOCKER"
terraform_validator_container_artifact_repository_description = "terraform-validator Container Artifact Registry Repository created with Terraform"
terraform_validator_container_artifact_repository_labels      = { "repository" : "terraform-validator-container" }