#! /bin/sh

# Create state bucket
#gsutil mb 

# Set variables
REPO_OWNER="Burwood"
REPO_NAME="terraform-gcp-sde"
TF_STATE_BUCKET="terraform-state-sde-1292"
TF_STATE_PREFIX="foundation/cb-iam"
TF_VERSION="0.13.5"
ORG_ID="645343216837"
FOLDER_ID="411225293317"
BILLING_ID="01EF01-627C10-7CD2DF"


# Enable services
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable billingbudgets.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable accesscontextmanager.googleapis.com
gcloud services enable oslogin.googleapis.com

# Grant Cloudbuild SA permissions

gcloud beta builds triggers create github \
--name="bootstrap-cb-iam-sde-plan" \
--repo-owner=${REPO_OWNER} \
--repo-name=${REPO_NAME} \
--branch-pattern="^main$" \
--included-files="environment/foundation/bootstrap-cb-iam-sde/terraform.tfvars" \
--build-config="cloudbuild/foundation/boostrap-cb-iam-sde-plan.yaml" \
--substitutions _BUCKET=${TF_STATE_BUCKET},_PREFIX=${TF_STATE_PREFIX},_TAG=${TF_VERSION}


gcloud beta builds triggers create github \
--name="bootstrap-cb-iam-sde-apply" \
--repo-owner=${REPO_OWNER} \
--repo-name=${REPO_NAME} \
--branch-pattern="^main$" \
--included-files="environment/foundation/bootstrap-cb-iam-sde/terraform.tfvars" \
--build-config="cloudbuild/foundation/boostrap-cb-iam-sde-plan.yaml" \
--substitutions _BUCKET=${TF_STATE_BUCKET},_PREFIX=${TF_STATE_PREFIX},_TAG=${TF_VERSION}


# Update Constants Values
sed -i "s/ORG_ID_REPLACE/${ORG_ID}/g" ../environment/foundation/constants/constants.tf
sed -i "s/FOLDER_ID_REPLACE/${FOLDER_ID}/g" ../environment/foundation/constants/constants.tf
sed -i "s/BILLING_ID_REPLACE/${BILLING_ID}/g" ../environment/foundation/constants/constants.tf