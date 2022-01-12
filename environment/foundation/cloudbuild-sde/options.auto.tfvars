terraform_container_version = "0.13.5" // TERRAFORM TAG 

#----------------------------------
# CLOUDBUILD TRIGGERS - PLAN TFVARS
#----------------------------------

srde_plan_trigger_name = [
  "packer-project",
  "researcher-projects",
  "staging-project",
  "srde-folder-policies",
  "data-lake"
]

srde_plan_trigger_tags     = []
srde_plan_trigger_disabled = false

srde_plan_trigger_invert_regex = true


#-----------------------------------
# CLOUDBUILD TRIGGERS - APPLY TFVARS
#-----------------------------------

srde_apply_trigger_name = [
  "packer-project",
  "researcher-projects",
  "staging-project",
  "srde-folder-policies",
  "data-lake"
]

srde_apply_trigger_tags     = []
srde_apply_trigger_disabled = false

srde_apply_trigger_invert_regex = false


#-------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER PLAN TFVARS
#-------------------------------------------

composer_plan_trigger_tags     = []
composer_plan_trigger_disabled = false

#-------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER APPLY TFVARS
#-------------------------------------------

srde_composer_apply_trigger_tags     = []
srde_composer_apply_trigger_disabled = false

#--------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL PLAN TFVARS
#--------------------------------------------------------------------------

srde_cloudbuild_sa_access_level_plan_trigger_tags     = []
srde_cloudbuild_sa_access_level_plan_trigger_disabled = false

#---------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL APPLY TFVARS
#---------------------------------------------------------------------------

srde_cloudbuild_sa_access_level_apply_trigger_tags     = []
srde_cloudbuild_sa_access_level_apply_trigger_disabled = false

#--------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL PLAN TFVARS
#--------------------------------------------------------------------------

srde_admin_access_level_plan_trigger_tags     = []
srde_admin_access_level_plan_trigger_disabled = false

#-----------------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL APPLY TFVARS
#-----------------------------------------------------------

srde_admin_access_level_apply_trigger_tags     = []
srde_admin_access_level_apply_trigger_disabled = false

#-------------------------------------------------------
# CLOUDBUILD TRIGGERS - DEEP LEARNING IMAGE BUILD TFVARS
#-------------------------------------------------------

srde_deep_learning_vm_image_build_trigger_tags     = []
srde_deep_learning_vm_image_build_trigger_disabled = false
srde_packer_image_tag                              = "1.7.3"

#--------------------------------------------------
# CLOUDBUILD TRIGGERS - RHEL CIS IMAGE BUILD TFVARS
#--------------------------------------------------

srde_rhel_cis_image_build_trigger_tags     = []
srde_rhel_cis_image_build_trigger_disabled = false

#----------------------------------------------------
# CLOUDBUILD TRIGGERS - PACKER CONTAINER IMAGE TFVARS
#----------------------------------------------------

srde_packer_container_image_build_trigger_tags     = []
srde_packer_container_image_build_trigger_disabled = false

#-----------------------------------------------------
# CLOUDBUILD TRIGGERS - PATH ML CONTAINER IMAGE TFVARS
#-----------------------------------------------------

srde_path_ml_container_image_build_trigger_tags     = []
srde_path_ml_container_image_build_trigger_disabled = false

#-----------------------------------------------------
# CLOUDBUILD TRIGGERS - PATH ML CONTAINER IMAGE TFVARS
#-----------------------------------------------------

srde_terraform_validator_container_image_build_trigger_tags     = []
srde_terraform_validator_container_image_build_trigger_disabled = false

#-------------------------
# FOLDER IAM MEMBER TFVARS
# Folder IAM permissions at the SRDE-DEV level
#-------------------------

iam_role_list = [
  "roles/bigquery.dataOwner",
  "roles/cloudbuild.builds.builder",
  "roles/composer.environmentAndStorageObjectAdmin",
  "roles/compute.instanceAdmin.v1",
  "roles/compute.networkAdmin",
  "roles/iam.serviceAccountAdmin",
  "roles/iam.serviceAccountUser",
  "roles/pubsub.admin",
  "roles/resourcemanager.projectCreator",
  "roles/resourcemanager.projectIamAdmin",
  "roles/serviceusage.serviceUsageConsumer",
  "roles/storage.admin"
]