import json
from os import listdir
from os.path import isfile, join

import os


print ("------------------------------------------------------------")
for k, v in sorted(os.environ.items()):
    print(k+':', v)
print('\n')

# open JSON file
researcher_tf_state_file = open('/workspace/researcher-output.json')
staging_tf_state_file = open('/workspace/staging-output.json')

# parse JSON output file
researcher_tf_state =  json.load(researcher_tf_state_file)

print ("------------------------------------------------------------")
print(researcher_tf_state)

print ("------------------------------------------------------------")
staging_tf_state =  json.load(staging_tf_state_file)

print(staging_tf_state)

print ("------------------------------------------------------------------------------------------------------------")

# the result is a Python dictionary -- print nested key values and set as variables
print(staging_tf_state["staging_project_id"]["value"])
STAGING_PROJECT_ID = staging_tf_state["staging_project_id"]["value"]

print(staging_tf_state["staging_pubsub_subscription_gcs_events"]["value"])
STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS = staging_tf_state["staging_pubsub_subscription_gcs_events"]["value"]

print(staging_tf_state["staging_bq_dataset"]["value"]["dataset_id"])
STAGING_BQ_DATASET = staging_tf_state["staging_bq_dataset"]["value"]["dataset_id"]

print ("------------------------------------------------------------------------------------------------------------")

print(researcher_tf_state["staging_gcs_ingress_bucket"]["value"])
STAGING_GCS_INGRESS_BUCKET = researcher_tf_state["staging_gcs_ingress_bucket"]["value"]

print(researcher_tf_state["staging_gcs_egress_bucket"]["value"])
STAGING_GCS_EGRESS_BUCKET = researcher_tf_state["staging_gcs_egress_bucket"]["value"]

print(researcher_tf_state["workspace_project_id"]["value"])
SDE_NAME = researcher_tf_state["workspace_project_id"]["value"]

print(researcher_tf_state["workspace_project_id"]["value"])
WORKSPACE_PROJECT_ID = researcher_tf_state["workspace_project_id"]["value"]

print(researcher_tf_state["workspace_gcs_ingress_bucket"]["value"])
WORKSPACE_GCS_INGRESS_BUCKET = researcher_tf_state["workspace_gcs_ingress_bucket"]["value"]

print(researcher_tf_state["workspace_gcs_egress_bucket"]["value"])
WORKSPACE_GCS_EGRESS_BUCKET = researcher_tf_state["workspace_gcs_egress_bucket"]["value"]

print(researcher_tf_state["researcher_dlp_result_bq_dataset"]["value"])
RESEARCHER_DLP_BQ_DATASET = researcher_tf_state["researcher_dlp_result_bq_dataset"]["value"]["dataset_id"]

print(researcher_tf_state["external_data_egress_project_id"]["value"])
EXTERNAL_PROJECT_ID = researcher_tf_state["external_data_egress_project_id"]["value"]

print(researcher_tf_state["external_gcs_egress_bucket"]["value"])
EXTERNAL_GCS_EGRESS_BUCKET = researcher_tf_state["external_gcs_egress_bucket"]["value"]

print ("------------------------------------------------------------")
# close file
researcher_tf_state_file.close()
staging_tf_state_file.close()

# get list of files prefixed with '_' and iterate
dag_file_names = [f for f in listdir('.') if isfile(join('.', f))]

for dag_file_name in dag_file_names:
  if dag_file_name.startswith('_'):

    # read in the DAG template file
    with open(dag_file_name, 'r') as file :
      filedata = file.read()

    # replace the target env variable strings
    filedata = filedata.replace('[%%[SDE_NAME]%%]', SDE_NAME)
    filedata = filedata.replace('[%%[STAGING_PROJECT_ID]%%]', STAGING_PROJECT_ID)
    filedata = filedata.replace('[%%[STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS]%%]', STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS)
    filedata = filedata.replace('[%%[STAGING_BQ_DATASET]%%]', STAGING_BQ_DATASET)
    filedata = filedata.replace('[%%[STAGING_GCS_INGRESS_BUCKET]%%]', STAGING_GCS_INGRESS_BUCKET)
    filedata = filedata.replace('[%%[STAGING_GCS_EGRESS_BUCKET]%%]', STAGING_GCS_EGRESS_BUCKET)
    filedata = filedata.replace('[%%[WORKSPACE_PROJECT_ID]%%]', WORKSPACE_PROJECT_ID)
    filedata = filedata.replace('[%%[WORKSPACE_GCS_INGRESS_BUCKET]%%]', WORKSPACE_GCS_INGRESS_BUCKET)
    filedata = filedata.replace('[%%[WORKSPACE_GCS_EGRESS_BUCKET]%%]', WORKSPACE_GCS_EGRESS_BUCKET)
    filedata = filedata.replace('[%%[RESEARCHER_DLP_BQ_DATASET]%%]', RESEARCHER_DLP_BQ_DATASET)
    filedata = filedata.replace('[%%[EXTERNAL_PROJECT_ID]%%]', EXTERNAL_PROJECT_ID)
    filedata = filedata.replace('[%%[EXTERNAL_GCS_EGRESS_BUCKET]%%]', EXTERNAL_GCS_EGRESS_BUCKET)

    # write the file out to new DAG in workspace
    final_dag = "/workspace/{}_{}".format(SDE_NAME, dag_file_name)

    with open(final_dag, 'w') as file:
      file.write(filedata)

    # print to prove
    with open(final_dag, 'r') as f:
        print(f.read())
    
  print ("------------------------------------------------------------")    