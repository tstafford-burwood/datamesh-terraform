# Cloud Composer DAG files

## Usage

All files in here are template files and should not be removed.

`set_notify_envs.py` is a script being used to create the `srde_Notify.py` file which is then written to the `/dags/` directory of the Cloud Composer bucket. The file writing and uploading is handled within the `cloudbuild-composer-apply.yaml` file.

## Process

### Ingress

- 1. Copy data to Staging Ingress bucket that corresponds with the targeted Research Workspace
- 2. Data Steward runs Ingress DAG #1

### Egress

- 1. Research team members copy files to be exported to the 'export' folder in the Researcher Workspace Egress bucket
- 2. Data Steward runs Egress DAG #1 to move files to the Staging Egress folder
    - This step also creates archive copies of the files in the Researcher Workspace Egress folder.
- 3. Data Steward runs Egress DAG #2 to perform DLP scan
    - A. DLP inspection findings are written to BigQuery
    - B. Data steward examines DLP scan results in BigQuery
- 4. Data Steward approves or denies movement to the external egress bucket:
    - A. If DLP scan results are NOT approved, Data Steward runs Egress DAG #3
    - D. If DLP scan results ARE approved, Data Steward runs Egress DAG #4

