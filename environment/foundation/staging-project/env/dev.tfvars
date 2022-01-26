#-----------------------
# PROJECT FACTORY TFVARS
#-----------------------

project_name = "aws2-staging" // CHANGE BEFORE FIRST DEPLOYMENT

gcs_events_bigquery_access              = []

#-------------------------------------
# BIGQUERY DATASET - GCS EVENTS TFVARS
#-------------------------------------

#gcs_events_dataset_id = "srde_gcs_events"

#--------------------------------------------
# VPC SC ACCESS LEVELS TFVARS - DATA STEWARDS
#--------------------------------------------

#access_level_name    = "aar2_staging_data_stewards"                                 // CHANGE NAME IF NEEDED, DATA STEWARDS ACCESS
#access_level_members = ["user:dspeck@sde.burwood.io"] // CHANGE AS NEEDED WITH DATA STEWARD INDIVIDUALS

#---------------------------------------------------------
# VPC SC REGULAR PERIMETER TFVARS - SECURE STAGING PROJECT
# This is creating the permiter around the staging project and giving it
# the name declared in the `staging_project_regular_service_perimeter_name` variable.
#---------------------------------------------------------

// REQUIRED TFVARS

#staging_project_regular_service_perimeter_name = "aar2n_staging_project_perimeter"

#------------------------------------------
# DATA STEWARDS - PROJECT IAM MEMBER TFVARS
#------------------------------------------

// USED TO SET role/composer.user AND custom srde role ON THE STAGING PROJECT FOR DATA STEWARDS TO ACCESS CLOUD COMPOSER

data_stewards_iam_staging_project = ["user:dspeck@sde.burwood.io"]