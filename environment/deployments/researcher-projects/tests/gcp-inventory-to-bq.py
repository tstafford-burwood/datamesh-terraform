# ------------------------------------------------------------
#  Load GCP Asset Inventory into BigQuery
# ------------------------------------------------------------


from google.cloud import asset_v1
from google.cloud import bigquery
import google.auth
import os

# ------------------------------------------------------------
#  create_bq_dataset
# ------------------------------------------------------------


def create_bq_dataset(credentials, bq_project_id, dataset_name):

    # Construct a BigQuery client object.
    client = bigquery.Client(credentials=credentials, project=bq_project_id)

    ds = client.create_dataset(dataset_name, exists_ok=True, timeout=300)

    return ds

# ------------------------------------------------------------
#  list_asset_resources
# ------------------------------------------------------------


def list_asset_resources(credentials, project_id, asset_types, content_type, page_size):

    project_resource = "projects/{}".format(project_id)
    client = asset_v1.AssetServiceClient(credentials=credentials)

    response = client.list_assets(
        request={
            "parent": project_resource,
            "read_time": None,
            "asset_types": asset_types,
            "content_type": content_type,
            "page_size": page_size,
        }
    )

    for asset in response:
        print(asset.name)

# ------------------------------------------------------------
#  export_asset_resources_to_bq
# ------------------------------------------------------------


def export_asset_resources_to_bq(credentials, project_id, content_type, dataset):

    project_resource = "projects/{}".format(project_id)
    client = asset_v1.AssetServiceClient(credentials=credentials)

    client = asset_v1.AssetServiceClient()
    output_config = asset_v1.OutputConfig()
    # Note: Need to remove leading '/' char from dataset.path, otherwise calls 
    # to client.export_assets will fail with the following error:
    # - "Invalid format in BigQuery destination dataset in request."
    output_config.bigquery_destination.dataset = dataset.path[1:]
    output_config.bigquery_destination.table = content_type
    output_config.bigquery_destination.force = True
    response = client.export_assets(
        request={
            "parent": project_resource,
            "content_type": content_type,
            "output_config": output_config
        }
    )

    print(response.result())

# ------------------------------------------------------------
#  main
# ------------------------------------------------------------


if __name__ == "__main__":

    # Note: APIs must be enabled for your project before running this code.
    # For a list of all Google API OAuth scopes, see: https://developers.google.com/identity/protocols/oauth2/scopes
    # - For access to all Google Cloud services, use "https://www.googleapis.com/auth/cloud-platform"
    credentials, bq_project_id = google.auth.default(
        scopes=[
            "https://www.googleapis.com/auth/cloud-platform"
        ]
    )

    #  content_type ="Content type to list"
    # ----------------------------------------
    #  CONTENT_TYPE_UNSPECIFIED = 0  | Unspecified content type.
    #  RESOURCE = 1                  | Resource metadata.
    #  IAM_POLICY = 2                | The actual IAM policy set on a resource.
    #  ORG_POLICY = 4                | The Cloud Organization Policy set on an asset.
    #  ACCESS_POLICY = 5             | The Cloud Access context manager Policy set on an asset.
    #  OS_INVENTORY = 6              | The runtime OS Inventory information.
    #  RELATIONSHIP = 7              | The related resources.

    asset_types = []  # Examples: ["storage.googleapis.com/Bucket","bigquery.googleapis.com/Table"]
    content_type = "RESOURCE"
    page_size = 10  # must be between 1 and 1000 (both inclusively)
    list_asset_resources(credentials, bq_project_id,
                         asset_types, content_type, page_size)

    dataset_name = "gcp_assets_2021_11_10"

    bq_dataset = create_bq_dataset(credentials, bq_project_id, dataset_name)

    project_ids = ["", "", "", "", "", "", ""]

    for project_id in project_ids:
        export_asset_resources_to_bq(credentials, project_id,
                                     "CONTENT_TYPE_UNSPECIFIED", bq_dataset)

        export_asset_resources_to_bq(credentials, project_id,
                                     "RESOURCE", bq_dataset)

        export_asset_resources_to_bq(credentials, project_id,
                                     "IAM_POLICY", bq_dataset)

        export_asset_resources_to_bq(credentials, project_id,
                                     "ORG_POLICY", bq_dataset)

        export_asset_resources_to_bq(credentials, project_id,
                                     "ACCESS_POLICY", bq_dataset)

        export_asset_resources_to_bq(credentials, project_id,
                                     "OS_INVENTORY", bq_dataset)

        export_asset_resources_to_bq(credentials, project_id,
                                     "RELATIONSHIP", bq_dataset)
