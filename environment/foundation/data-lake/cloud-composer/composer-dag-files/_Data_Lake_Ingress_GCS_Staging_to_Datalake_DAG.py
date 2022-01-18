"""
[%%[SDE_NAME]%%]_DataLake_Ingress_GCS_Staging_to_Datalake_DAG.py
"""

#  Workflow Summary
# ================================================================================
#  1. Move all files from the Staging project's ingress bucket to the 
#     Data Lake project's bucket
#     - All files will be copied to a time-stamped folder to avoid overwriting 
#       existing files of the same name.


#  Notes for ops support
# ================================================================================
#  Guide to troubleshooting DAGs: https://cloud.google.com/composer/docs/how-to/using/troubleshooting-dags#troubleshooting_workflow


#  Google Cloud resource dependencies
# ================================================================================
#  Resource Management
#  1. SDE folder
#    - Policies & Permissions
#  
#  2. Staging project
#     - Cloud Composer
#     - GCS bucket
#       - Data Lake Ingress bucket
#  3. Data Lake project
#     - GCS bucket

from airflow import models
from airflow.providers.google.cloud.transfers.gcs_to_gcs import GCSToGCSOperator
from airflow.utils.dates import days_ago

# ============================================================
#  Secure Data Environment
# ============================================================

SDE_NAME="[%%[SDE_NAME]%%]"

# ============================================================
#  Staging project
# ============================================================

# STAGING_PROJECT_ID="[%%[STAGING_PROJECT_ID]%%]"
# STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS="[%%[STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS]%%]"
# STAGING_BQ_TABLE_GCS_EVENTS="[%%[STAGING_PROJECT_ID]%%].wcm_srde.gcs_events"

STAGING_DATA_LAKE_INGRESS_GCS_BUCKET="[%%[STAGING_DATA_LAKE_INGRESS_GCS_BUCKET]%%]"

# ============================================================
#  Data Lake project
# ============================================================

# DATA_LAKE_PROJECT_ID = "[%%[DATA_LAKE_PROJECT_ID]%%]"
DATA_LAKE_GCS_BUCKET="[%%[DATA_LAKE_GCS_BUCKET]%%]"

# ============================================================
#  DAG
# ============================================================

DAG_ID="[%%[SDE_NAME]%%]_DataLake_Ingress_GCS_Staging_to_Datalake_DAG"

with models.DAG(
    dag_id=DAG_ID,
    description="Move all files in the [%%[SDE_NAME]%%] data lake staging ingress bucket to the [%%[SDE_NAME]%%] data lake bucket.",
    schedule_interval=None,  # This DAG must be triggered manually
    start_date=days_ago(1),
    catchup=False,
    access_control={
        "[%%[SDE_NAME]%%]": {"can_dag_read", "can_dag_edit"}
    },
    tags=['[%%[SDE_NAME]%%]', 'gcs', 'ingress', 'transfer']
) as dag:

    # ================================================================================
    #  Task: move_files_task
    # ================================================================================

    move_files_task = GCSToGCSOperator(
        task_id="move_files",
        source_bucket=STAGING_DATA_LAKE_INGRESS_GCS_BUCKET,
        source_object="*",
        destination_bucket=DATA_LAKE_GCS_BUCKET,
        destination_object="{{ run_id }}/",
        move_object=True,
        replace=False
    )
    
    move_files_task
