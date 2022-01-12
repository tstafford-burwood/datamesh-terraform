#-----------------
# CONSTANT VALUES
#-----------------
locals {
  constants = {

    // DOMAIN INFORMATION

    org_id                     = "645343216837" // CHANGE BEFORE FIRST DEPLOYMENT
    billing_account_id         = "01EF01-627C10-7CD2DF" // CHANGE BEFORE FIRST DEPLOYMENT
    srde_folder_id             = "398150021301" // CHANGE BEFORE FIRST DEPLOYMENT
    automation_project_id      = "automation-dan-sde" // CHANGE BEFORE FIRST DEPLOYMEN
    cloudbuild_service_account = "547140210872@cloudbuild.gserviceaccount.com" // CHANGE BEFORE FIRST DEPLOYMENT

    // PACKER PROJECT INFORMATION

    packer_project_id                 = "aaron3-packer-ba08" //CHANGE AFTER PROVISIONING PACKER PROJECT
    packer_base_image_id_bastion      = "packer-1639578676" // CHANGE AFTER NEW IMAGE IS CREATED
    packer_base_image_id_deeplearning = "" // CHANGE AFTER NEW IMAGE IS CREATED
    packer_default_region             = "us-central1" // SELECT A DEFAULT REGION. `us-central1` has been selected as a default

    // STAGING PROJECT INFORMATION

    staging_project_id = "" // CHANGE AFTER PROVISIONING STAGING PROJECT
    staging_default_region = "us-central1"

    // DATA LAKE PROJECT INFORMATION

    data_lake_project_id = "" // CHANGE AFTER PROVISIONING DATA LAKE PROJECT
    data_lake_default_region = "us-central1" // SELECT A DEFAULT REGION. `us-central1` has been selected as a default

    // WORKSPACE PROJECT INFORMATION

    workspace_default_region = "us-central1" // SELECT A DEFAULT REGION. `us-central1` has been selected as a default

    // BASTION PROJECT INFORMATION

    bastion_default_region = "us-central1"

    // VPC SERVICE CONTROL INFORMATION

    # Use gcloud cmd to create access policy (https://cloud.google.com/access-context-manager/docs/create-access-policy#gcloud)
    parent_access_policy_id          = "709551633793" // CHANGE BEFORE FIRST DEPLOYMENT (one time setup at Org Level - deployed with gcloud cmd)
    cloudbuild_access_level_name     = "aar4_cloud_build_service_account" // CHANGE AFTER PROVISIONING CLOUDBUILD VPC SC ACCESS LEVEL
    srde_admin_access_level_name     = "aar4_group_members" // CHANGE AFTER ACCESS LEVEL IS PROVISIONED
    cloud_composer_access_level_name = "" // CHANGE AFTER VPC SC ACCESS LEVEL IS PROVISIONED
    


    vpc_sc_all_restricted_apis = [
      "accessapproval.googleapis.com",
      "adsdatahub.googleapis.com",
      "aiplatform.googleapis.com",
      "apigee.googleapis.com",
      "apigeeconnect.googleapis.com",
      "artifactregistry.googleapis.com",
      "assuredworkloads.googleapis.com",
      "automl.googleapis.com",
      "bigquery.googleapis.com",
      "bigquerydatatransfer.googleapis.com",
      "bigtable.googleapis.com",
      "binaryauthorization.googleapis.com",
      "cloudasset.googleapis.com",
      "cloudbuild.googleapis.com",
      "cloudfunctions.googleapis.com",
      "cloudkms.googleapis.com",
      "cloudprofiler.googleapis.com",
      "cloudresourcemanager.googleapis.com",
      "cloudsearch.googleapis.com",
      "cloudtrace.googleapis.com",
      "composer.googleapis.com",
      "compute.googleapis.com",
      "connectgateway.googleapis.com",
      "contactcenterinsights.googleapis.com",
      "container.googleapis.com",
      "containeranalysis.googleapis.com",
      "containerregistry.googleapis.com",
      "containerthreatdetection.googleapis.com",
      "datacatalog.googleapis.com",
      "dataflow.googleapis.com",
      "datafusion.googleapis.com",
      "dataproc.googleapis.com",
      "dialogflow.googleapis.com",
      "dlp.googleapis.com",
      "dns.googleapis.com",
      "documentai.googleapis.com",
      "eventarc.googleapis.com",
      "file.googleapis.com",
      "gameservices.googleapis.com",
      "gkeconnect.googleapis.com",
      "gkehub.googleapis.com",
      "healthcare.googleapis.com",
      "iam.googleapis.com",
      "iaptunnel.googleapis.com",
      "language.googleapis.com",
      "lifesciences.googleapis.com",
      "logging.googleapis.com",
      "managedidentities.googleapis.com",
      "memcache.googleapis.com",
      "meshca.googleapis.com",
      "metastore.googleapis.com",
      "ml.googleapis.com",
      "monitoring.googleapis.com",
      "networkconnectivity.googleapis.com",
      "networkmanagement.googleapis.com",
      "networksecurity.googleapis.com",
      "networkservices.googleapis.com",
      "notebooks.googleapis.com",
      "opsconfigmonitoring.googleapis.com",
      "osconfig.googleapis.com",
      "oslogin.googleapis.com",
      "privateca.googleapis.com",
      # "pubsub.googleapis.com",
      "pubsublite.googleapis.com",
      "recaptchaenterprise.googleapis.com",
      "recommender.googleapis.com",
      "redis.googleapis.com",
      "run.googleapis.com",
      "secretmanager.googleapis.com",
      "servicecontrol.googleapis.com",
      "servicedirectory.googleapis.com",
      "spanner.googleapis.com",
      "speech.googleapis.com",
      "sqladmin.googleapis.com",
      "storage.googleapis.com",
      "storagetransfer.googleapis.com",
      "sts.googleapis.com",
      "texttospeech.googleapis.com",
      "tpu.googleapis.com",
      "trafficdirector.googleapis.com",
      "transcoder.googleapis.com",
      "translate.googleapis.com",
      "videointelligence.googleapis.com",
      "vision.googleapis.com",
      "vpcaccess.googleapis.com"
    ]
  }
}