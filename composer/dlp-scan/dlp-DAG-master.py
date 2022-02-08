import datetime

from airflow import DAG
from airflow.providers.google.cloud.transfers.gcs_to_gcs import GCSToGCSOperator
from airflow.providers.google.cloud.operators.kubernetes_engine import KubernetesPodOperator

start_date = datetime.datetime.now()
default_args = {
    'start_date': start_date,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=20),
}

with DAG("new-gke-cluster-dag", start_date=start_date, params=default_args) as dag:
    dlp_scan = KubernetesPodOperator(
        task_id="dlp_scan",
        namespace="default",
        image='gcr.io/composer-sde-test/dlp',
        cmds=["python3", "_Egress_2_Staging_DLP_Inspection_Scan.py"],
        name="dlp_task1_pod",
        service_account_name="composer"
    )

    move_files_task = GCSToGCSOperator(
        task_id="move_files",
        source_bucket="inspection11", #STAGING_GCS_EGRESS_BUCKET
        source_object="inspection/*",
        destination_bucket="inspection11", #STAGING_GCS_EGRESS_BUCKET
        destination_object="post-inspection/dlp_scan_{{ run_id }}/",
        move_object=True,
        replace=False
    )
    # Define the order the tasks run in 
    dlp_scan >> move_files_task