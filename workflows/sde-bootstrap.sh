#! /bin/sh

# Create state bucket
#gsutil mb 

# Set variables
REPO_OWNER="Burwood"
REPO_NAME="terraform-gcp-sde"
TF_STATE_BUCKET="terraform-state-sde-1292"
TF_STATE_PREFIX="foundation"
TF_VERSION="0.13.5"

ORG_ID="645343216837"
FOLDER_ID="48819915135"
BILLING_ID="01EF01-627C10-7CD2DF"
AUTOMATION_PROJECT_ID="automation-dan-sde"


# Enable services
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable billingbudgets.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable accesscontextmanager.googleapis.com
gcloud services enable oslogin.googleapis.com

# Grant Cloudbuild SA permissions

if ! gcloud beta builds triggers describe cloudbuild-sde-plan ; then
    gcloud beta builds triggers create github \
        --name="cloudbuild-sde-plan" \
        --repo-owner=${REPO_OWNER} \
        --repo-name=${REPO_NAME} \
        --branch-pattern="^main$" \
        --included-files="environment/foundation/cloudbuild-sde/terraform.tfvars" \
        --build-config="cloudbuild/foundation/cloudbuild-sde-plan.yaml" \
        --substitutions _BUCKET=${TF_STATE_BUCKET},_PREFIX=${TF_STATE_PREFIX},_TAG=${TF_VERSION}
else
    echo "cloudbuild-sde-plan already created"
fi

if ! gcloud beta builds triggers describe cloudbuild-sde-apply ; then
    gcloud beta builds triggers create github \
        --name="cloudbuild-sde-apply" \
        --repo-owner=${REPO_OWNER} \
        --repo-name=${REPO_NAME} \
        --branch-pattern="^main$" \
        --included-files="environment/foundation/cloudbuild-sde/terraform.tfvars" \
        --build-config="cloudbuild/foundation/cloudbuild-sde-apply.yaml" \
        --substitutions _BUCKET=${TF_STATE_BUCKET},_PREFIX=${TF_STATE_PREFIX},_TAG=${TF_VERSION}
else
    echo "cloudbuild-sde-apply already created"
fi

if ! gcloud beta builds triggers describe cloudbuild-sde-destroy ; then
    gcloud beta builds triggers create github \
        --name="cloudbuild-sde-destroy" \
        --repo-owner=${REPO_OWNER} \
        --repo-name=${REPO_NAME} \
        --branch-pattern="^main$" \
        --included-files="environment/foundation/cloudbuild-sde/terraform.tfvars" \
        --build-config="cloudbuild/foundation/cloudbuild-sde-destroy.yaml" \
        --require-approval \
        --substitutions _BUCKET=${TF_STATE_BUCKET},_PREFIX=${TF_STATE_PREFIX},_TAG=${TF_VERSION}
else
    echo "cloudbuild-sde-apply already created"
fi


# Update Constants Values
sed -i "s/ORG_ID_REPLACE/${ORG_ID}/g" ../environment/foundation/constants/constants.tf
sed -i "s/FOLDER_ID_REPLACE/${FOLDER_ID}/g" ../environment/foundation/constants/constants.tf
sed -i "s/BILLING_ID_REPLACE/${BILLING_ID}/g" ../environment/foundation/constants/constants.tf
sed -i "s/AUTOMATION_PROJECT_ID_REPLACE/${AUTOMATION_PROJECT_ID}/g" ../environment/foundation/constants/constants.tf

# Set Cloudbuild account
PROJECT_NUMBER=$(gcloud projects describe automation-dan-sde  --format='value(projectNumber)')

# Add Cloudbuild SA Account to Folder
gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} \
    --role roles/resourcemanager.folderAdmin \
    --member "serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"

sed -i "s/CLOUDBUILD_SA_REPLACE/${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com/g" ../environment/foundation/constants/constants.tf