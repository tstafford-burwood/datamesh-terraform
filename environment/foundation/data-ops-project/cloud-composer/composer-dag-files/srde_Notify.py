"""
srde_Notify.py
"""

#  Workflow Summary
# ================================================================================
#  1. Wait for GCS events from the Staging project's PubSub subscription.
#  2. Receive GCS events via PubSubPullSensor
#     - Callback
#     - Check size before writing to XCom (fail if size > 48K)
#  3. Report events to BigQuery via PythonOperator


#  Notes for ops support
# ================================================================================
#  Guide to troubleshooting DAGs: https://cloud.google.com/composer/docs/how-to/using/troubleshooting-dags#troubleshooting_workflow


#  Google Cloud resource dependencies
# ================================================================================
#  SDE folder
#  - Policies & Permissions
#  
#  1. Staging project
#     - Cloud Composer
#     - PubSub topic for receiving GCS events
#     - GCS buckets configured with GCS notifications
#       - Ingress bucket
#       - Egress bucket
#     - BigQuery
#       - Dataset w/ permissions for Cloud Composer to connect
#         - Table for GCS events
#
#  2. Researcher workspace project
#  
#  3. Egress project


import json
import proto

from airflow import models
# from airflow.operators.dagrun_operator import TriggerDagRunOperator
from airflow.providers.google.cloud.sensors.pubsub import PubSubPullSensor
from airflow.utils.dates import days_ago

from google.cloud import bigquery

# ============================================================
#  Secure Data Environment
# ============================================================

SDE_NAME="wcm-srde"

# ============================================================
#  Staging project
# ============================================================

STAGING_PROJECT_ID="[%%[STAGING_PROJECT_ID]%%]"
STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS="[%%[STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS]%%]"
STAGING_BQ_TABLE_GCS_EVENTS="[%%[STAGING_PROJECT_ID]%%].wcm_srde.gcs_events"


# ============================================================
#  DAG
# ============================================================

DAG_ID="srde_Notify"

def proto_message_to_dict(message: proto.Message) -> dict:
    """Helper method to parse protobuf message to dictionary."""
    return json.loads(message.__class__.to_json(message))


with models.DAG(
    dag_id=DAG_ID,
    description="Receive notifications of GCS events",
    schedule_interval="0-59/5 * * * *",  # Try to start 5 minutes (if not already running)
    start_date=days_ago(1),
    max_active_runs=3,
    # dagrun_timeout=(default is 1 week)
    catchup=False,
    tags=[SDE_NAME, 'pubsub', 'gcs']
) as dag:



    # ================================================================================    
    #  Task: pull_messages_task
    # ================================================================================

    # ------------------------------------------------------------
    #  pull_messages_task - Callback for the PubSubPullSensor
    # ------------------------------------------------------------

    def pull_messages_callback (messages, context):
        m_collection = []

        dag = context['dag']
        task = context['task']
        ti = context['ti']

        print("========================================")
        print(f"Received message count: {len(messages)}")
        print("----------------------------------------")
        if len(messages) == 0:
            return

        for m in messages:

            #  Convert ReceivedMessage to Python dictionary
            # ------------------------------------------------------------            
            m_dict = proto_message_to_dict(m)                            # Convert from 'google.cloud.pubsub_v1.types.ReceivedMessage' to Python dictionary            
            m_dict['message']['data'] = json.loads(m.message.data)       # Decode base64-encoded message.data

            #  Transform message.data.metadata for insertion into BigQuery
            # ------------------------------------------------------------
            original_metadata = m_dict['message']['data'].get('metadata')
            new_metadata = []
            if original_metadata:
                for mdata_key, mdata_value in original_metadata.items():     # Iterate over metadata key-value pairs and create list
                    new_metadata.append(dict(key=mdata_key, value=mdata_value))
            m_dict['message']['data']['metadata'] = new_metadata

            #  Add Airflow context properties
            # ------------------------------------------------------------  
            m_dict['message']['context'] = {
                'dag_tags': dag.tags,
                'task_project_id': task.project_id,
                'ti_dag_id': ti.dag_id,
                'task_instance_key_str': context['task_instance_key_str'],
                'run_id': context['run_id'],
                'ts': context['ts']
            }

            #  Add top-level timestamp field
            # ------------------------------------------------------------
            m_dict['gcs_event_ts'] = m_dict['message']['attributes'].get('eventTime')

            m_collection.append(m_dict)

        #  Write to BigQuery
        # ------------------------------------------------------------
        client = bigquery.Client()

        # print(f"json.dumps(m_collection): {json.dumps(m_collection)}")

        # TODO: Check size. Fail if exceeds 48K

        errors = client.insert_rows_json(STAGING_BQ_TABLE_GCS_EVENTS, m_collection)  # Make an API request.

        if errors == []:
            print("New rows have been added.")
        else:
            error_message = f"Encountered errors while inserting rows: {errors}"
            print(error_message)
            raise RuntimeError(error_message)

        return m_collection


    # ------------------------------------------------------------    
    #  pull_messages_task - PubSubPullSensor configuration
    # ------------------------------------------------------------       
  
    pull_messages_task = PubSubPullSensor(
        task_id="pull_messages",
        project_id=STAGING_PROJECT_ID,
        subscription=STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS,
        max_messages=8,
        ack_messages=True,
        messages_callback=pull_messages_callback,        
        poke_interval=60, # TODO: Using 15 seconds for development. Set to 60+ seconds for release?
        # exponential_backoff=True, # This setting is ignored in the current version.
        timeout=60 * 60 * 24 * 7 # Wait for up to 1 week.
    )



    # ================================================================================    
    #  Task: trigger_dag_run_task
    # ================================================================================    

    # trigger_dag_run_task = TriggerDagRunOperator(
    #     task_id="trigger_dag_run",
    #     trigger_dag_id=DAG_ID
    # )

    pull_messages_task # >> trigger_dag_run_task
