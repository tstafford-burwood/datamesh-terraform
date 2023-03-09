data "archive_file" "cf_egress_module_zip" {
  output_path = "${path.module}/egress_build_fn.zip"
  type        = "zip"
  source_dir  = "${path.module}/functions/egress"

  depends_on = [
    local_file.composer_1_cf_egress_main_py[0]
  ]
}

data "http" "webui" {
  # Get the CLIENT ID
  count  = startswith(local.composer_version, "composer-1") ? 1 : 0
  url    = local.composer_ariflow_uri
  method = "GET"
}

resource "google_storage_bucket_object" "cf_egress_module_zip" {
  bucket       = google_storage_bucket.function_archive_storage.name
  name         = "cf_egress_module.zip"
  content_type = "application/zip"
  source       = data.archive_file.cf_egress_module_zip.output_path
}

resource "local_file" "composer_1_cf_egress_main_py" {
  # Create the template file separately from the archive_file block
  count    = startswith(local.composer_version, "composer-1") ? 1 : 0 # Composer-2 does not require CLIENT_ID
  filename = "${path.module}/functions/egress/main.py"
  content = templatefile("${path.module}/functions/main.py.tpl", {

    # `DataOps_to_EgressPrj_DAG` is found in the ./scripts/*.tpl file
    DAG_NAME             = format("%s_%s", lower(replace(local.researcher_workspace_name, "-", "_")), "DataOps_to_Egress_DAG")
    WEBSERVER_ID         = trimsuffix(trimprefix(local.composer_ariflow_uri, "https://"), ".appspot.com")
    CLIENT_ID            = trimprefix(regex("[A-Za-z0-9-]*\\.apps\\.googleusercontent\\.com", data.http.webui[count.index].response_headers["X-Auto-Login"]), "253D")
    USE_EXPERIMENTAL_API = "True"
  })

}


resource "local_file" "composer_2_cf_egress_main_py" {
  # Create the template file separately from the archive_file block
  count    = startswith(local.composer_version, "composer-2") ? 1 : 0
  filename = "${path.module}/functions/composer2/egress/main.py"
  content = templatefile("${path.module}/functions/composer2/main.py.tpl", {

    # `DataOps_to_EgressPrj_DAG` is found in the ./scripts/*.tpl file
    DAG_NAME    = format("%s_%s", lower(replace(local.researcher_workspace_name, "-", "_")), "DataOps_to_Egress_DAG")
    AIRFLOW_URI = local.composer_ariflow_uri
  })
}

resource "local_file" "composer_2_cf_egress_restapi_py" {
  # Create the template file separately from the archive_file block
  count    = startswith(local.composer_version, "composer-2") ? 1 : 0
  filename = "${path.module}/functions/composer2/egress/composer2_airflow_rest_api.py"
  content = templatefile("${path.module}/functions/composer2/composer2_airflow_rest_api.py.tpl", {

    # `DataOps_to_EgressPrj_DAG` is found in the ./scripts/*.tpl file
    # DAG_NAME             = format("%s_%s", lower(replace(local.researcher_workspace_name, "-", "_")), "DataOps_to_Egress_DAG")
    # AIRFLOW_URI         = local.composer_ariflow_uri
  })
}


resource "google_cloudfunctions_function" "egress" {

  project               = local.staging_project_id
  name                  = format("%s-%s", "cf", trimprefix(trim(local_file.dataops_to_egress_dag_py.filename, ".py"), "/scripts/"))
  runtime               = "python310"
  description           = format("Research initiative: %s", lower(replace(local.researcher_workspace_name, "-", "_")))
  available_memory_mb   = 256
  entry_point           = "http_trigger"
  region                = var.region
  timeout               = 60
  min_instances         = 0
  max_instances         = 10
  service_account_email = local.composer_sa

  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"

  # Use the Serveless VPC Connector in the Data Ops project
  ingress_settings              = "ALLOW_ALL"
  vpc_connector                 = local.vpc_connector
  vpc_connector_egress_settings = "ALL_TRAFFIC"

  source_archive_bucket = google_storage_bucket.function_archive_storage.name
  source_archive_object = google_storage_bucket_object.cf_egress_module_zip.name

}


resource "google_cloudfunctions_function_iam_member" "invoker" {
  # IAM entry for Application Integration SA found in Data Ops project
  project        = local.staging_project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.egress.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:service-${local.staging_project_number}@gcp-sa-integrations.iam.gserviceaccount.com"
}

# Delete Module

resource "local_file" "composer_1_cf_delete_main_py" {
  # Create the template file separately from the archive_file block
  count    = startswith(local.composer_version, "composer-1") ? 1 : 0 # Composer-2 does not require CLIENT_ID
  filename = "${path.module}/functions/delete/main.py"
  content = templatefile("${path.module}/functions/main.py.tpl", {

    # `deletePrj_DAG` is found in the ../../env/foundation/data-ops/cloud-composer/*.tpl file
    DAG_NAME             = format("%s_%s", lower(replace(local.researcher_workspace_name, "-", "_")), "DataOps_Delete_DAG")
    WEBSERVER_ID         = trimsuffix(trimprefix(local.composer_ariflow_uri, "https://"), ".appspot.com")
    CLIENT_ID            = trimprefix(regex("[A-Za-z0-9-]*\\.apps\\.googleusercontent\\.com", data.http.webui[count.index].response_headers["X-Auto-Login"]), "253D")
    USE_EXPERIMENTAL_API = "True"
  })

}

data "archive_file" "cf_delete_module_zip" {
  output_path = "${path.module}/delete_build_fn.zip"
  type        = "zip"
  source_dir  = "${path.module}/functions/delete"

  depends_on = [
    local_file.composer_1_cf_delete_main_py[0]
  ]
}

resource "google_storage_bucket_object" "cf_delete_module_zip" {
  bucket       = google_storage_bucket.function_archive_storage.name
  name         = "cf_delete_module.zip"
  content_type = "application/zip"
  source       = data.archive_file.cf_delete_module_zip.output_path
}

resource "google_cloudfunctions_function" "delete" {

  project               = local.staging_project_id
  name                  = format("%s-%s-%s-%s", "cf", local.environment[terraform.workspace], local.researcher_workspace_name, "delete-dag")
  runtime               = "python310"
  description           = format("Research initiative: %s", lower(replace(local.researcher_workspace_name, "-", "_")))
  available_memory_mb   = 256
  entry_point           = "http_trigger"
  region                = var.region
  timeout               = 60
  min_instances         = 0
  max_instances         = 10
  service_account_email = local.composer_sa

  # Use the Serveless VPC Connector in the Data Ops project
  ingress_settings              = "ALLOW_ALL"
  vpc_connector                 = local.vpc_connector
  vpc_connector_egress_settings = "ALL_TRAFFIC"

  source_archive_bucket = google_storage_bucket.function_archive_storage.name
  source_archive_object = google_storage_bucket_object.cf_delete_module_zip.name

  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"

}

resource "google_cloudfunctions_function_iam_member" "invoker_delete" {
  # IAM entry for Application Integration SA found in Data Ops project
  project        = local.staging_project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.delete.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:service-${local.staging_project_number}@gcp-sa-integrations.iam.gserviceaccount.com"
}