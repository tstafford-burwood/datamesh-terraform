import json
from os import listdir
from os.path import isfile, join

import os


print ("------------------------------------------------------------")
for k, v in sorted(os.environ.items()):
    print(k+':', v)
print('\n')

# open JSON file
data_lake_tf_state_file = open('/workspace/data-lake-output.json')
staging_tf_state_file = open('/workspace/staging-output.json')

# parse JSON output file
data_lake_tf_state =  json.load(data_lake_tf_state_file)

print ("------------------------------------------------------------")
print(data_lake_tf_state)

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

print(data_lake_tf_state["staging_data_lake_ingress_gcs_bucket"]["value"])
STAGING_DATA_LAKE_INGRESS_GCS_BUCKET = data_lake_tf_state["staging_data_lake_ingress_gcs_bucket"]["value"]

print(data_lake_tf_state["staging_data_lake_ingress_bq_dataset"]["value"]["dataset_id"])
STAGING_DATA_LAKE_INGRESS_BQ_DATASET = data_lake_tf_state["staging_data_lake_ingress_bq_dataset"]["value"]["dataset_id"]

print(data_lake_tf_state["data_lake_project_id"]["value"])
SDE_NAME = data_lake_tf_state["data_lake_project_id"]["value"]

print(data_lake_tf_state["data_lake_project_id"]["value"])
DATA_LAKE_PROJECT_ID = data_lake_tf_state["data_lake_project_id"]["value"]

print(data_lake_tf_state["data_lake_gcs_bucket"]["value"])
DATA_LAKE_GCS_BUCKET = data_lake_tf_state["data_lake_gcs_bucket"]["value"]

print(data_lake_tf_state["data_lake_bq_dataset"]["value"])
DATA_LAKE_BQ_DATASET = data_lake_tf_state["data_lake_bq_dataset"]["value"]["dataset_id"]

print ("------------------------------------------------------------")
# close file
data_lake_tf_state_file.close()
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
    filedata = filedata.replace('[%%[STAGING_DATA_LAKE_INGRESS_BQ_DATASET]%%]', STAGING_DATA_LAKE_INGRESS_BQ_DATASET)
    filedata = filedata.replace('[%%[STAGING_DATA_LAKE_INGRESS_GCS_BUCKET]%%]', STAGING_DATA_LAKE_INGRESS_GCS_BUCKET)
    filedata = filedata.replace('[%%[DATA_LAKE_PROJECT_ID]%%]', DATA_LAKE_PROJECT_ID)
    filedata = filedata.replace('[%%[DATA_LAKE_GCS_BUCKET]%%]', DATA_LAKE_GCS_BUCKET)
    filedata = filedata.replace('[%%[DATA_LAKE_BQ_DATASET]%%]', DATA_LAKE_BQ_DATASET)

    # write the file out to new DAG in workspace
    final_dag = "/workspace/{}_{}".format(SDE_NAME, dag_file_name)

    with open(final_dag, 'w') as file:
      file.write(filedata)

    # print to prove
    with open(final_dag, 'r') as f:
        print(f.read())
    
  print ("------------------------------------------------------------")    