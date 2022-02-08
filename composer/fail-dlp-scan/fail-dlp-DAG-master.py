import datetime

from airflow import DAG
from airflow.providers.google.cloud.operators.kubernetes_engine import KubernetesPodOperator

start_date = datetime.datetime.now()
default_args = {
    'start_date': start_date,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=20),
}

with DAG("fail-dlp-delete-files-dag", start_date=start_date, params=default_args) as dag:
    delete_files = KubernetesPodOperator(
        task_id="delete_failed_files",
        namespace="default",
        image='gcr.io/composer-sde-test/fail-dlp-delete-files',
        cmds=["python3", "_Egress_3_Staging_Fail_Inspection_DAG.py"],
        name="delete_files_task_pod",
        service_account_name="composer"
    )

    # Define the order the tasks run in 
    delete_files