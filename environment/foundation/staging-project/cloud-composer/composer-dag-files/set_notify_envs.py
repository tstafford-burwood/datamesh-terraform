import json
import os

# open JSON file
x = open('/workspace/output.json')

# parse JSON output file
y =  json.load(x)


# the result is a Python dictionary -- print nested key values and set as variables
print(y["staging_project_id"]["value"])
env1 = y["staging_project_id"]["value"]
print(y["staging_pubsub_subscription_gcs_events"]["value"])
env2 = y["staging_pubsub_subscription_gcs_events"]["value"]
print(y["staging_bq_dataset"]["value"]["dataset_id"])
env3 = y["staging_bq_dataset"]["value"]["dataset_id"]


# close file
x.close()

# read in the DAG template file
with open('srde_Notify.py', 'r') as file :
  filedata = file.read()

# replace the target env variable strings
filedata = filedata.replace('[%%[SDE_NAME]%%]', env1)
filedata = filedata.replace('[%%[STAGING_PROJECT_ID]%%]', env1)
filedata = filedata.replace('[%%[STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS]%%]', env2)
filedata = filedata.replace('[%%[STAGING_BQ_DATASET]%%]', env3)

# write the file out to new DAG in workspace
final_dag = '/workspace/srde_Notify.py'

with open(final_dag, 'w') as file:
  file.write(filedata)

# #print to prove
# with open('/workspace/srde_Notify.py', 'r') as f:
#     print(f.read())