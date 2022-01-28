terraform_container_version = "0.13.5" // TERRAFORM TAG 

#----------------------------------
# CLOUDBUILD TRIGGERS - PLAN TFVARS
#----------------------------------

plan_trigger_tags     = []
plan_trigger_disabled = false

plan_trigger_invert_regex = true


#-----------------------------------
# CLOUDBUILD TRIGGERS - APPLY TFVARS
#-----------------------------------


apply_trigger_tags     = []
apply_trigger_disabled = false

apply_trigger_invert_regex = false


#-------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER PLAN TFVARS
#-------------------------------------------

composer_plan_trigger_tags     = []
composer_plan_trigger_disabled = false

#-------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER APPLY TFVARS
#-------------------------------------------

composer_apply_trigger_tags     = []
composer_apply_trigger_disabled = false

#--------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL PLAN TFVARS
#--------------------------------------------------------------------------

cloudbuild_sa_access_level_plan_trigger_tags     = []
cloudbuild_sa_access_level_plan_trigger_disabled = false

#---------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL APPLY TFVARS
#---------------------------------------------------------------------------

cloudbuild_sa_access_level_apply_trigger_tags     = []
cloudbuild_sa_access_level_apply_trigger_disabled = false

#--------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL PLAN TFVARS
#--------------------------------------------------------------------------

access_level_admin_plan_trigger_tags     = []
access_level_admin_plan_trigger_disabled = false

#-----------------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL APPLY TFVARS
#-----------------------------------------------------------

access_level_admin__apply_trigger_tags     = []
access_level_admin_apply_trigger_disabled = false

#-------------------------------------------------------
# CLOUDBUILD TRIGGERS - DEEP LEARNING IMAGE BUILD TFVARS
#-------------------------------------------------------

deep_learning_vm_image_build_trigger_tags     = []
deep_learning_vm_image_build_trigger_disabled = false
packer_image_tag                              = "1.7.3"

#--------------------------------------------------
# CLOUDBUILD TRIGGERS - RHEL CIS IMAGE BUILD TFVARS
#--------------------------------------------------

rhel_cis_image_build_trigger_tags     = []
rhel_cis_image_build_trigger_disabled = false

#----------------------------------------------------
# CLOUDBUILD TRIGGERS - PACKER CONTAINER IMAGE TFVARS
#----------------------------------------------------

packer_container_image_build_trigger_tags     = []
packer_container_image_build_trigger_disabled = false

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