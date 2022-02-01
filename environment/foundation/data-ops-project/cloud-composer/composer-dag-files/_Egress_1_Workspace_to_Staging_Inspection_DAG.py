"""
[%%[SDE_NAME]%%]_Egress_1_Workspace_to_Staging_Inspection_DAG.py
"""

#  Workflow Summary
# ================================================================================
#  1. Copy all files from the 'export' folder of a Workspace project's 
#     egress bucket to an 'archive' folder in the Workspace project's egress bucket
#  2. Move all files from the 'export' folder of the Workspace project's 
#     egress bucket to an inspection folder in the Staging project's egress bucket
#   
#  Note: In all cases, files will be copied to a time-stamped sub-folder to avoid 
#        overwriting existing files of the same name.


#  Notes for ops support
# ================================================================================
#  Guide to troubleshooting DAGs: 
#  https://cloud.google.com/composer/docs/how-to/using/troubleshooting-dags#troubleshooting_workflow


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
#  3. Researcher workspace project
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

DAG_ID="[%%[SDE_NAME]%%]_Egress_1_Workspace_to_Staging_Inspection"

with models.DAG(
    dag_id=DAG_ID,
    description="Copy all files from the [%%[SDE_NAME]%%] workspace egress bucket to an inspection folder in the [%%[SDE_NAME]%%] staging egress bucket.",
    schedule_interval=None,  # This DAG must be triggered manually
    start_date=days_ago(1),
    catchup=False,
    access_control={
        "[%%[SDE_NAME]%%]": {"can_dag_read", "can_dag_edit"}
    },
    tags=['[%%[SDE_NAME]%%]', 'gcs', 'egress', 'transfer']
) as dag:

    # ================================================================================
    #  Task: archive_files_task
    # ================================================================================

    archive_files_task = GCSToGCSOperator(
        task_id="archive_files",
        source_bucket=WORKSPACE_GCS_EGRESS_BUCKET,
        source_object="export/",
        destination_bucket=WORKSPACE_GCS_EGRESS_BUCKET,
        destination_object="archived/{{ run_id }}/",
        move_object=False,
        replace=False
    )

    # ================================================================================
    #  Task: move_files_task
    # ================================================================================

    move_files_task = GCSToGCSOperator(
        task_id="move_files",
        source_bucket=WORKSPACE_GCS_EGRESS_BUCKET,
        source_object="export/",
        destination_bucket=STAGING_GCS_EGRESS_BUCKET,
        destination_object="inspection/ws_export_{{ run_id }}/",
        move_object=True,
        replace=True
    )
    
    archive_files_task >> move_files_task
