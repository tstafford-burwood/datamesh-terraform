"""
[%%[SDE_NAME]%%]_Egress_4_Staging_Pass_Inspection_DAG.py
"""

#  Workflow Summary
# ================================================================================
#  1. Move all files from the post-inspection folder in the Staging project's 
#     egress bucket to the egress bucket in the External project
#     - All files will be copied to a time-stamped folder to avoid overwriting 
#       existing files of the same name.


#  Notes for ops support
# ================================================================================
#  Guide to troubleshooting DAGs: https://cloud.google.com/composer/docs/how-to/using/troubleshooting-dags#troubleshooting_workflow


#  Google Cloud resource dependencies
# ================================================================================
#  Resource Managemer
#  1. SDE folder
#    - Policies & Permissions
#  
#  2. Staging project
#     - Cloud Composer
#     - GCS bucket
#       - Egress bucket
#  3. Researcher External project
#     - GCS bucket
#       - Egress bucket

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

STAGING_PROJECT_ID="[%%[STAGING_PROJECT_ID]%%]"
STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS="[%%[STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS]%%]"
STAGING_BQ_TABLE_GCS_EVENTS="[%%[STAGING_PROJECT_ID]%%].wcm_srde.gcs_events"

STAGING_GCS_INGRESS_BUCKET="[%%[STAGING_GCS_INGRESS_BUCKET]%%]"
STAGING_GCS_EGRESS_BUCKET="[%%[STAGING_GCS_EGRESS_BUCKET]%%]"

# ============================================================
#  Researcher workspace project
# ============================================================

WORKSPACE_PROJECT_ID = "[%%[WORKSPACE_PROJECT_ID]%%]"
WORKSPACE_GCS_INGRESS_BUCKET="[%%[WORKSPACE_GCS_INGRESS_BUCKET]%%]"
WORKSPACE_GCS_EGRESS_BUCKET="[%%[WORKSPACE_GCS_EGRESS_BUCKET]%%]"

# ============================================================
#  External project
# ============================================================

EXTERNAL_PROJECT_ID = "[%%[EXTERNAL_PROJECT_ID]%%]"
EXTERNAL_GCS_EGRESS_BUCKET="[%%[EXTERNAL_GCS_EGRESS_BUCKET]%%]"

# ============================================================
#  DAG
# ============================================================

DAG_ID="[%%[SDE_NAME]%%]_Egress_4_Staging_Pass_Inspection"

with models.DAG(
    dag_id=DAG_ID,
    description="Move all files from the post-inspection folder of the [%%[SDE_NAME]%%] staging egress bucket to the [%%[SDE_NAME]%%] external egress bucket.",
    schedule_interval=None,  # This DAG must be triggered manually
    start_date=days_ago(1),
    catchup=False,
    access_control={
        "[%%[SDE_NAME]%%]": {"can_dag_read", "can_dag_edit"}
    },
    tags=['[%%[SDE_NAME]%%]', 'gcs', 'egress', 'transfer']
) as dag:


    # ================================================================================
    #  Task: move_files_task
    # ================================================================================

    move_files_task = GCSToGCSOperator(
        task_id="move_files",
        source_bucket=STAGING_GCS_EGRESS_BUCKET,
        source_object="post-inspection/",
        destination_bucket=EXTERNAL_GCS_EGRESS_BUCKET,
        destination_object="inspection_passed_{{ run_id }}/",
        move_object=True,
        replace=False
    )
    
    move_files_task
