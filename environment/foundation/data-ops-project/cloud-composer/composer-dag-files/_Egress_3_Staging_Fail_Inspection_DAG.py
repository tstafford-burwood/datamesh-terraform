"""
[%%[SDE_NAME]%%]_Egress_3_Staging_Fail_Inspection_DAG.py
"""

#  Workflow Summary
# ================================================================================
#  1. Delete all files from the 'inspection' and  'post-inspection' folders
#     in the Staging project's egress bucket.
#  
#  Note: Be aware that prematurely canceling an operation midway through a job 
#        still incurs costs for the portion of the job that was completed.

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


from airflow import models
from airflow.operators.python_operator import PythonOperator
from airflow.providers.google.cloud.operators.gcs import GCSDeleteObjectsOperator
from airflow.utils.dates import days_ago

from google.cloud import storage
from google.cloud.exceptions import NotFound
from google.api_core.exceptions import RetryError, GoogleAPICallError

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

DAG_ID="[%%[SDE_NAME]%%]_Egress_3_Staging_Fail_Inspection"

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
    #  Task: Delete files from the staging inspection & post-inspection folders
    # ================================================================================

    def delete_files_callable(**kwargs):
        """Delete files from the staging inspection & post-inspection folders."""

        print("========================================")
        print(f"delete_files_callable()")
        print("----------------------------------------")

        #  Run DLP job
        # ------------------------------------------------------------
        client = storage.Client()

        try:
            bucket = client.get_bucket(STAGING_GCS_EGRESS_BUCKET)
            # list all objects in the directory
            blobs = bucket.list_blobs()
            for blob in blobs:
                print(f"deleting file: {blob}")
                blob.delete()
        except NotFound as notfound_error:
            print (notfound_error)
            raise
        # except ValueError as value_error:
        #     print(value_error)
        #     raise
        # except RetryError as retry_error:
        #     print(retry_error)
        #     raise
        except GoogleAPICallError as api_call_error:
            print(api_call_error)
            raise

    py_delete_files_task = PythonOperator(
        task_id="py_delete_files",
        python_callable=delete_files_callable,
        provide_context=True
    )

    # ================================================================================
    #  Task: delete_files
    # ================================================================================

    # delete_files_task = GCSDeleteObjectsOperator(
    #     task_id="delete_files",
    #     bucket_name=STAGING_GCS_EGRESS_BUCKET,
    #     # objects=["*"]  # List of objects to delete. These should be the names of objects in the bucket, not including gs://bucket/
    #     prefix="*"   # Prefix of objects to delete. All objects matching this prefix in the bucket will be deleted.
    # )

    # delete_files_task

    py_delete_files_task
