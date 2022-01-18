"""
[%%[SDE_NAME]%%]_DataLake_Ingress_BQ_Staging_to_Datalake_DAG.py
"""

#  Workflow Summary
# ================================================================================
#  1. Move all data from the Staging project's ingress BQ Dataset to the 
#     Data Lake project's BQ Dataset


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
#     - BQ Dataset
#       - Data Lake Ingress BQ Dataset
#  3. Data Lake project
#     - BQ Dataset

from airflow import models
from airflow.providers.google.cloud.transfers.bigquery_to_bigquery import BigQueryToBigQueryOperator
from airflow.utils.dates import days_ago

# ============================================================
#  Secure Data Environment
# ============================================================

SDE_NAME="[%%[SDE_NAME]%%]"

# ============================================================
#  Staging project
# ============================================================

STAGING_PROJECT_ID="[%%[STAGING_PROJECT_ID]%%]"
STAGING_DATA_LAKE_INGRESS_BQ_DATASET="[%%[STAGING_DATA_LAKE_INGRESS_BQ_DATASET]%%]"

# ============================================================
#  Data Lake project
# ============================================================

DATA_LAKE_PROJECT_ID = "[%%[DATA_LAKE_PROJECT_ID]%%]"
DATA_LAKE_BQ_DATASET="[%%[DATA_LAKE_BQ_DATASET]%%]"

# ============================================================
#  DAG
# ============================================================

DAG_ID="[%%[SDE_NAME]%%]_DataLake_Ingress_BQ_Staging_to_Datalake_DAG"

with models.DAG(
    dag_id=DAG_ID,
    description="Copy all data in the [%%[SDE_NAME]%%] data lake staging ingress BQ dataset to the [%%[SDE_NAME]%%] data lake BQ dataset.",
    schedule_interval=None,  # This DAG must be triggered manually
    start_date=days_ago(1),
    catchup=False,
    access_control={
        "[%%[SDE_NAME]%%]": {"can_dag_read", "can_dag_edit"}
    },
    tags=['[%%[SDE_NAME]%%]', 'bq', 'ingress', 'transfer']
) as dag:

    # ================================================================================
    #  Task: move_files_task
    # ================================================================================

    copy_bq_data_task = BigQueryToBigQueryOperator(
        task_id="copy_bq_data",
        source_project_dataset_tables = STAGING_PROJECT_ID + ":" + STAGING_DATA_LAKE_INGRESS_BQ_DATASET + ".tbl_staging_ingress",
        destination_project_dataset_table= DATA_LAKE_PROJECT_ID + ":" + DATA_LAKE_BQ_DATASET + ".tbl_data_lake",
        write_disposition='WRITE_EMPTY',
        create_disposition='CREATE_IF_NEEDED',
        # labels: Optional[Dict] = None,
        # location: Optional[str] = None,
    )
    
    copy_bq_data_task
