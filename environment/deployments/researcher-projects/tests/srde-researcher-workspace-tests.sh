#!/bin/sh

# Function to display commands
show_message_h1() { 
  set +x
  echo ============================================================
  echo "  $1"
  echo ============================================================
  set -x
}

show_message_h2() { 
  set +x
  echo ------------------------------------------------------------
  echo "  $1"
  echo ------------------------------------------------------------
  set -x
}

set +x
# ============================================================
show_message_h1 "Researcher workspace test script"
# ============================================================
#  If necessary, run the following command to fix line breaks:
#    sed -i -e 's/\r$//' srde-researcher-workspace-tests.sh
# set -x

set +x
# ----------------------------------------
show_message_h2 "Environment variables"
# ----------------------------------------

# Projects:
export WORKSPACE_PROJECT_ID=group2-poc-srde-workspace-f5cc
export BASTION_PROJECT_ID=group2-poc-srde-bastion-1e5f
export EXTERNAL_PROJECT_ID=group2-srde-data-egress-734d
export STAGING_PROJECT_ID=wcm-srde-test-staging-e923
export DATALAKE_PROJECT_ID=srde-test-data-lake-be92

# Buckets:
export WORKSPACE_GCS_INGRESS_BUCKET=wcm-us-east1-researcher2-workspace-ingress-7ebd
export WORKSPACE_GCS_EGRESS_BUCKET=wcm-us-east1-researcher2-workspace-egress-0364
export WORKSPACE_GCS_WORKING_BUCKET=wcm-us-central1-researcher2-workspace-dl-vm-6c3c
export DATALAKE_GCS_BUCKET=wcm-us-central1-srde-test-data-lake-dd19
export EXTERNAL_GCS_EGRESS_BUCKET=
export STAGING_GCS_DATALAKE_INGRESS_BUCKET=
export STAGING_GCS_WORKSPACE_INGRESS_BUCKET=
export STAGING_GCS_WORKSPACE_EGRESS_BUCKET=

# BQ Datasets

export WORKSPACE_BQ_DATASET=group2-poc-srde-workspace-f5cc:researcher2_workspace_vm_dataset
export DATALAKE_BQ_DATASET=srde-test-data-lake-be92:srde_test_data_lake_dataset
export STAGING_DATALAKE_BQ_DATASET=

# VMs:
export BASTION_VM=bastion-vm-cis-rhel
export BASTION_VM_ZONE=us-east4-a

export WORKSPACE_VM_1=deep-learning-vm2
export WORKSPACE_VM_1_ZONE=us-east4-a

export WORKSPACE_VM_2=path-ml-vm
export WORKSPACE_VM_2_ZONE=us-central1-a

# Cloud Source Repos:
export WORKSPACE_CLOUD_SOURCE_REPO=

# Containers:
export PATHML_CONTAINER_REPO=us-central1-docker.pkg.dev/packer-test-srde-wcm-ad97/pathml-docker-repo
export PATHML_CONTAINER_IMAGE=us-central1-docker.pkg.dev/packer-test-srde-wcm-ad97/pathml-docker-repo/pathml-image:tag1

# DAGs:

# Pub/sub:
export STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS=

# TPUs:
export TPU_NAME=test-tpu
export TPU_EXECUTION_GROUP_NAME=test-execution-group
export TPU_ZONE=us-central1-b
export TPU_ACCELERATOR_TYPE=v2-8
export TPU_TENSORFLOW_VERSION=2.4.1 # pytorch-1.10


set +x
# ========================================
show_message_h1 "Researcher workspace test cases"
# ========================================


set +x
# ----------------------------------------
show_message_h2 "Init for researcher workspace test cases"
# ----------------------------------------

echo $HOSTNAME
echo $USER

gcloud config list
gcloud config set core/project $WORKSPACE_PROJECT_ID


set +x
# ----------------------------------------
show_message_h2 "GCS tests"
# ----------------------------------------

gsutil ls -p $WORKSPACE_PROJECT_ID

gsutil ls "gs://${WORKSPACE_GCS_INGRESS_BUCKET}/**"
gsutil ls "gs://${WORKSPACE_GCS_EGRESS_BUCKET}/**"
gsutil ls "gs://${WORKSPACE_GCS_WORKING_BUCKET}/**"

gsutil ls -p $DATALAKE_PROJECT_ID

gsutil ls "gs://${DATALAKE_GCS_BUCKET}/**"


set +x
# ----------------------------------------
show_message_h2 "BigQuery tests"
# ----------------------------------------
set +x

bq ls
bq ls publicdata:
bq ls $WORKSPACE_BQ_DATASET
bq ls $DATALAKE_BQ_DATASET


set +x
# ----------------------------------------
show_message_h2 "Google Cloud Source tests"
# ----------------------------------------


set +x
# ----------------------------------------
show_message_h2 "Google Compute Engine tests"
# ----------------------------------------

gcloud compute instances list 


set +x
# ----------------------------------------
show_message_h2 "Google Compute Engine TPU tests"
# ----------------------------------------

# Test TPU management

gcloud compute tpus locations list
gcloud compute tpus accelerator-types list --zone=$TPU_ZONE
gcloud compute tpus versions list --zone=$TPU_ZONE
gcloud compute tpus list --zone=$TPU_ZONE

gcloud compute tpus create $TPU_NAME --zone=$TPU_ZONE --range='10.240.0.0/29' --accelerator-type='v2-8' --network=researcher2-poc-workspace-vpc --description='My TF Node' --version='2.4.1'
gcloud compute tpus stop $TPU_NAME --zone=$TPU_ZONE
# gcloud compute tpus reimage $TPU_NAME --zone=$TPU_ZONE
gcloud compute tpus start $TPU_NAME --zone=$TPU_ZONE
gcloud compute tpus delete $TPU_NAME --zone=$TPU_ZONE



set +x
# ========================================
show_message_h1 "All tests completed"
# ========================================


# Other tests
# - GCS - create/destroy bucket, create/delete object
# - BQ
# - DLP
# - DAGS - execute each DAG
# - Compute (all VMs)
# - Containers
# - Client access
#   - Notebooks
#   - Bastion
#   - Composer UI
# - Security Controls
#   - Org
#   - VPC SC perimeters
#   - IAM (Org, Folder, Project)
#   - Resource-level controls




