
"""
[%%[SDE_NAME]%%]_Egress_2_Staging_DLP_Inspection_Scan_DAG.py
"""

#  Workflow Summary
# ================================================================================
#  1. Execute a DLP inspection job on all files in the 'inspection' folder of the
#     Staging project's egress bucket
#  2. Move all files from the 'inspection' folder of the Staging project's
#     egress bucket to a 'post-inspection' folder in the Staging project's egress bucket
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
#      - Be sure that the Cloud DLP service account is permitted to read your resources.
#        - DLP Service Account: service-<PROJECT_NUMBER>@dlp-api.iam.gserviceaccount.com
#
#  2. Staging project
#     - Cloud Composer
#     - GCS bucket
#       - Ingress bucket
#  3. Researcher workspace project
#     - GCS bucket
#       - Ingress bucket
#
#  4. Data Studio (optional)
#     - https://cloud.google.com/dlp/docs/analyzing-and-reporting#create_a_report_in
#
import os
from pprint import pprint

from airflow import models
from airflow.operators.python_operator import PythonOperator
from airflow.providers.google.cloud.transfers.gcs_to_gcs import GCSToGCSOperator
from airflow.providers.google.cloud.operators.dlp import CloudDLPCreateDLPJobOperator
from airflow.utils.dates import days_ago

from google.cloud import dlp_v2
from google.api_core.exceptions import RetryError, GoogleAPICallError

# ============================================================
#  Secure Data Environment
# ============================================================

SDE_NAME = "[%%[SDE_NAME]%%]"

# ============================================================
#  Staging project
# ============================================================

STAGING_PROJECT_ID = "[%%[STAGING_PROJECT_ID]%%]"
STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS = "[%%[STAGING_PUBSUB_SUBSCRIPTION_GCS_EVENTS]%%]"
STAGING_BQ_TABLE_GCS_EVENTS = "[%%[STAGING_PROJECT_ID]%%].wcm_srde.gcs_events"

STAGING_GCS_INGRESS_BUCKET = "[%%[STAGING_GCS_INGRESS_BUCKET]%%]"
STAGING_GCS_EGRESS_BUCKET = "[%%[STAGING_GCS_EGRESS_BUCKET]%%]"

# ============================================================
#  Researcher workspace project
# ============================================================

WORKSPACE_PROJECT_ID = "[%%[WORKSPACE_PROJECT_ID]%%]"
WORKSPACE_GCS_INGRESS_BUCKET = "[%%[WORKSPACE_GCS_INGRESS_BUCKET]%%]"
WORKSPACE_GCS_EGRESS_BUCKET = "[%%[WORKSPACE_GCS_EGRESS_BUCKET]%%]"
RESEARCHER_DLP_BQ_DATASET = "[%%[RESEARCHER_DLP_BQ_DATASET]%%]"

# ============================================================
#  External project
# ============================================================

EXTERNAL_PROJECT_ID = "[%%[EXTERNAL_PROJECT_ID]%%]"
EXTERNAL_GCS_EGRESS_BUCKET = "[%%[EXTERNAL_GCS_EGRESS_BUCKET]%%]"

# ============================================================
#  Data Loss Prevention (DLP)
# ============================================================

DLP_INSPECT_JOB_LOCATION = "us-east4"

DLP_INSPECT_JOB_CONFIG = {  # See https://googleapis.dev/python/dlp/1.0.0/gapic/v2/types.html#google.cloud.dlp_v2.types.InspectJobConfig
    # "jobId": "" # The job ID must be unique, and can contain uppercase and lowercase letters, numbers, and hyphens; that is, it must match the following regular expression: [a-zA-Z\\d-]+.
    "storage_config": {  # The data to scan.
        "cloud_storage_options": {
            "file_set": {  # The set of one or more files to scan. Exactly one of url or regexFileSet must be set.
                # The Cloud Storage url of the file(s) to scan, in the format gs://<bucket>/<path>. Trailing '**' enables a recursive scan.
                "url": "gs://[%%[STAGING_GCS_EGRESS_BUCKET]%%]/inspection/**",
            },
            # "bytes_limit_per_file_percent": 100,
            "bytes_limit_per_file_percent": 15,
            # "bytes_limit_per_file": 1000000,
            "file_types": ["FILE_TYPE_UNSPECIFIED"],  # Includes all files
            "sample_method": "RANDOM_START",
            "files_limit_percent": 100
        }
    },
    "inspect_config": {  # How and what to scan for.
        "info_types": [  # Restricts what infoTypes to look for.
            {"name": "AGE"},
            {"name": "CREDIT_CARD_NUMBER"},
            {"name": "CREDIT_CARD_TRACK_NUMBER"},
            {"name": "DATE"},
            {"name": "DATE_OF_BIRTH"},   # may impact performance
            {"name": "DOMAIN_NAME"},
            {"name": "EMAIL_ADDRESS"},
            {"name": "FIRST_NAME"},      # may impact performance
            {"name": "GENERIC_ID"},
            {"name": "HTTP_COOKIE"},
            {"name": "IP_ADDRESS"},
            {"name": "LAST_NAME"},       # may impact performance
            {"name": "MAC_ADDRESS"},
            {"name": "MAC_ADDRESS_LOCAL"},
            {"name": "PASSPORT"},
            {"name": "PERSON_NAME"},     # may impact performance
            {"name": "PHONE_NUMBER"},
            {"name": "STREET_ADDRESS"},  # may impact performance
            {"name": "URL"},
            {"name": "US_ADOPTION_TAXPAYER_IDENTIFICATION_NUMBER"},
            {"name": "US_DRIVERS_LICENSE_NUMBER"},
            {"name": "US_PASSPORT"},
            {"name": "US_PREPARER_TAXPAYER_IDENTIFICATION_NUMBER"},
            {"name": "US_SOCIAL_SECURITY_NUMBER"},
            {"name": "US_VEHICLE_IDENTIFICATION_NUMBER"},
            {"name": "VEHICLE_IDENTIFICATION_NUMBER"},
        ],
        # ["VERY_LIKELY" | "LIKELY" | "POSSIBLE" | "UNLIKELY" | "VERY_UNLIKELY" | "LIKELIHOOD_UNSPECIFIED"], Only returns findings equal or above this threshold. The default is POSSIBLE.
        "min_likelihood": "POSSIBLE",
        "limits": {  # Configuration to control the number of findings returned.
            # Max number of findings that will be returned for each item scanned. When set within InspectJobConfig, the maximum returned is 2000 regardless if this is set higher.
            "max_findings_per_item": 5000,
            # , # Max number of findings that will be returned per request/job
            "max_findings_per_request": 10000,
            "max_findings_per_info_type": [ # Configuration of findings limit given for specified infoTypes.
                {
                    # "infoType": {
                    #     "name": string # Type of information the findings limit applies to. Only one limit per infoType should be provided. If InfoTypeLimit does not have an infoType, the DLP API applies the limit against all infoTypes that are found but not specified in another InfoTypeLimit.
                    # },
                    "max_findings": 100 # Max findings limit for the given infoType.
                }
            ]
        },
        # When true, a contextual quote from the data that triggered a finding is included in the response
        "include_quote": True,
        # "exclude_info_types": boolean, # When true, excludes type information of the findings.
        "content_options": [  # List of options defining data content to scan. If empty, text, images, and other content will be included.
            # ["CONTENT_UNSPECIFIED" | "CONTENT_TEXT" | "CONTENT_IMAGE"] enum (ContentOption)
            "CONTENT_UNSPECIFIED"
        ]  # ,
        # "rule_set": { # Set of rules to apply to the findings for this InspectConfig. Exclusion rules, contained in the set are executed in the end, other rules are executed in the order they are specified for each info type.
        #     "info_types": [ # List of infoTypes this rule set is applied to.
        #         {
        #             "name": "PERSON_NAME"
        #         }
        #     ],
        #     "rules": [ # Set of rules (i.e. hotwordRules and exclusionRules) to be applied to infoTypes. The rules are applied in order.
        #         {
        #             "hotword_rule": {
        #                 "hotword_regex": { # Regular expression pattern defining what qualifies as a hotword.
        #                     "pattern": "patient", # Pattern defining the regular expression. Its syntax (https://github.com/google/re2/wiki/Syntax) can be found under the google/re2 repository on GitHub.
        #                     # "groupIndexes": [ # The index of the submatch to extract as findings. When not specified, the entire match is returned. No more than 3 may be included.
        #                     #     integer
        #                     # ]
        #                 },
        #                 "proximity": { # Proximity of the finding within which the entire hotword must reside. The total length of the window cannot exceed 1000 characters.
        #                     "window_before": 50, # Number of characters before the finding to consider.
        #                     # "windowAfter": integer # Number of characters after the finding to consider.
        #                 },
        #                 "likelihood_adjustment": { # Likelihood adjustment to apply to all matching findings.
        #                     "fixed_likelihood": "VERY_LIKELY" # Set the likelihood of a finding to a fixed value.
        #                 }
        #             }
        #         }
        #     ]
        # }
    },
    # If provided, will be used as the default for all values in InspectConfig. inspectConfig will be merged into the values persisted as part of the template.
    # "inspect_template_name": "[%%[STAGING_DLP_INSPECTION_TEMPLATE_ID]%%]",
    "actions": [  # Actions to execute at the completion of the job.
        {
            "save_findings": {  # Save resulting findings in a provided location.
                "output_config": {
                  # "outputSchema": enum (OutputSchema), # Schema used for writing the findings for Inspect jobs. This field is only used for Inspect and must be unspecified for Risk jobs.
                  "table": {  # Store findings in an existing table or a new table in an existing dataset. If tableId is not set a new one will be generated for you with the following format: dlp_googleapis_yyyy_mm_dd_[dlp_job_id]. Pacific timezone will be used for generating the date details.
                      # For Inspect, each column in an existing output table must have the same name, type, and mode of a field in the Finding object.
                      "project_id": "[%%[STAGING_PROJECT_ID]%%]",
                      "dataset_id": "[%%[RESEARCHER_DLP_BQ_DATASET]%%]"
                      # "tableId": "my-table-id" # Leave out the "tableId" key if you want to instruct Cloud DLP to create a new table every time the scan is run.
                  }
                }
            }
        }
    ]
}

# ============================================================
#  DAG
# ============================================================

DAG_ID = "[%%[SDE_NAME]%%]_Egress_2_Staging_DLP_Inspection_Scan"

with models.DAG(
    dag_id=DAG_ID,
    description="Perform DLP inspection scan on files in the 'inspection' folder of the staging bucket for [%%[SDE_NAME]%%].",
    schedule_interval=None,
    start_date=days_ago(1),
    max_active_runs=1,
    catchup=False,
    access_control={
        "[%%[SDE_NAME]%%]": {"can_dag_read", "can_dag_edit"}
    },
    # List of tags to help filtering DAGS in the UI.
    tags=['[%%[SDE_NAME]%%]', 'dlp', 'staging', 'inspection']
) as dag:

    # ================================================================================
    #  Task: Scan files for sensitive data
    # ================================================================================

    def create_dlp_job_callable(**kwargs):
        """Create and execute a DLP inspection job."""

        print("========================================")
        print(f"create_dlp_job_callable()")
        print("----------------------------------------")

        #  Run DLP job
        # ------------------------------------------------------------
        client = dlp_v2.DlpServiceClient()

        try:
            print("----------------------------------------")
            parent = f"projects/{STAGING_PROJECT_ID}/locations/{DLP_INSPECT_JOB_LOCATION}"
            print(f"parent: {parent}")
            dlp_job = client.create_dlp_job(
                parent, inspect_job=DLP_INSPECT_JOB_CONFIG)
            # print("----------------------------------------")
            # print(f"dlp_job: {dlp_job}")
            # print("----------------------------------------")
        except ValueError as value_error:
            print(value_error)
            raise
        except RetryError as retry_error:
            print(retry_error)
            raise
        except GoogleAPICallError as api_call_error:
            print(api_call_error)
            raise

    py_create_dlp_job_task = PythonOperator(
        task_id="py_create_dlp_job",
        python_callable=create_dlp_job_callable,
        provide_context=True
    )

    # ================================================================================
    #  Task: move_files_task
    # ================================================================================

    move_files_task = GCSToGCSOperator(
        task_id="move_files",
        source_bucket=STAGING_GCS_EGRESS_BUCKET,
        source_object="inspection/",
        destination_bucket=STAGING_GCS_EGRESS_BUCKET,
        destination_object="post-inspection/dlp_scan_{{ run_id }}/",
        move_object=True,
        replace=False
    )

    py_create_dlp_job_task >> move_files_task
