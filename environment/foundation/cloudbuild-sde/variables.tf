#-----------------------------------------
# CLOUDBUILD TRIGGERS - REQUIRED VARAIBLES
#-----------------------------------------

variable "data_lake_project_trigger_name" {
  description = "Name of data lake project trigger"
  type        = string
  default     = "data-lake"
}

variable "env_name_dev" {
  description = "Name of development environment to append to triggers"
  type        = string
  default     = "dev"
}

variable "env_name_prod" {
  description = "Name of production environment to append to triggers"
  type        = string
  default     = "prod"
}

variable "folders_trigger_name" {
  description = "Name of data lake project trigger"
  type        = string
  default     = "folders"
}

variable "github_owner" {
  description = "GitHub Organization Name"
  type        = string
  default     = ""
}

variable "github_repo_name" {
  description = "Name of GitHub Repo"
  type        = string
  default     = ""
}

variable "packer_project_trigger_name" {
  description = "Name of packer project trigger"
  type        = string
  default     = "packer-project"
}

variable "researcher_workspace_project_trigger_name" {
  description = "Name of data lake project trigger"
  type        = string
  default     = "researcher-workspace-project"
}

variable "staging_project_trigger_name" {
  description = "Name of staging project trigger"
  type        = string
  default     = "staging-project"
}

variable "terraform_state_bucket" {
  description = "The name of the state bucket where Terraform state will be stored."
  type        = string
  default     = ""
}

variable "terraform_state_prefix" {
  description = "The name of the prefix to create in the state bucket. This will end up creating additional sub-directories to store state files in an orderly fashion. The additional sub-directories are generally created as a declaration inside of the Cloud Build YAML file of each pipeline."
  type        = string
  default     = "cloudbuild-sde"
}

variable "terraform_foundation_state_prefix" {
  description = "The name of the foundation prefix to create in the state bucket. This will end up creating additional sub-directories to store state files in an orderly fashion. The additional sub-directories are generally created as a declaration inside of the Cloud Build YAML file of each pipeline."
  type        = string
  default     = "foundation"
}

variable "terraform_deployments_state_prefix" {
  description = "The name of the deployments prefix to create in the state bucket. This will end up creating additional sub-directories to store state files in an orderly fashion. The additional sub-directories are generally created as a declaration inside of the Cloud Build YAML file of each pipeline."
  type        = string
  default     = "deployments"
}

variable "terraform_container_version" {
  description = "The container version of Terraform to use with this pipeline during a Cloud Build build."
  type        = string
  default     = ""
}

#-------------------------------------
# CLOUDBUILD TRIGGERS - PLAN VARAIBLES
#-------------------------------------

variable "plan_trigger_project_id" {
  description = "The ID of the project in which the resource belongs and ID of the project that owns the Cloud Source Repository. If it is not provided, the provider project is used."
  type        = string
  default     = ""
}

variable "plan_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "plan_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

variable "plan_trigger_filename" {
  description = "Path, from the source root, to a file whose contents is used for the template. Either a filename or build template must be provided."
  type        = string
  default     = ""
}

variable "plan_trigger_included_files" {
  description = "ignoredFiles and includedFiles are file glob matches using https://golang.org/pkg/path/filepath/#Match extended with support for **. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is empty, then as far as this filter is concerned, we should trigger the build. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is not empty, then we make sure that at least one of those files matches a includedFiles glob. If not, then we do not trigger a build."
  type        = string
  default     = ""
}

variable "plan_trigger_repo_name" {
  description = "Name of the Cloud Source Repository. If omitted, the name `default` is assumed."
  type        = string
  default     = ""
}

variable "plan_trigger_invert_regex" {
  description = "Only trigger a build if the revision regex does NOT match the revision regex."
  type        = bool
  default     = false
}

variable "plan_branch_name" {
  description = "Regex matching branches to build. Exactly one a of branch name, tag, or commit SHA must be provided. The syntax of the regular expressions accepted is the syntax accepted by RE2 and described at https://github.com/google/re2/wiki/Syntax"
  type        = string
  default     = ""
}

variable "composer_dag_bucket" {
  description = "The name of the Cloud Composer DAG bucket. This will be necessary for some pipelines and not all pipelines. This value is obtained after the Cloud Composer instance is provisioned since it is a GCP managed resource."
  type        = string
  default     = ""
}

#--------------------------------------
# CLOUDBUILD TRIGGERS - APPLY VARAIBLES
#--------------------------------------

variable "apply_trigger_project_id" {
  description = "The ID of the project in which the resource belongs and ID of the project that owns the Cloud Source Repository. If it is not provided, the provider project is used."
  type        = string
  default     = ""
}

variable "apply_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "apply_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

variable "apply_trigger_filename" {
  description = "Path, from the source root, to a file whose contents is used for the template. Either a filename or build template must be provided."
  type        = string
  default     = ""
}

variable "apply_trigger_included_files" {
  description = "ignoredFiles and includedFiles are file glob matches using https://golang.org/pkg/path/filepath/#Match extended with support for **. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is empty, then as far as this filter is concerned, we should trigger the build. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is not empty, then we make sure that at least one of those files matches a includedFiles glob. If not, then we do not trigger a build."
  type        = string
  default     = ""
}

variable "apply_trigger_repo_name" {
  description = "Name of the Cloud Source Repository. If omitted, the name `default` is assumed."
  type        = string
  default     = ""
}

variable "apply_trigger_invert_regex" {
  description = "Only trigger a build if the revision regex does NOT match the revision regex."
  type        = bool
  default     = false
}

variable "apply_branch_name" {
  description = "Regex matching branches to build. Exactly one a of branch name, tag, or commit SHA must be provided. The syntax of the regular expressions accepted is the syntax accepted by RE2 and described at https://github.com/google/re2/wiki/Syntax"
  type        = string
  default     = ""
}

#----------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER PLAN VARIABLES
#----------------------------------------------

variable "composer_plan_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "composer_plan_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

#-----------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER APPLY VARIABLES
#-----------------------------------------------

variable "composer_apply_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "composer_apply_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

#-----------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL PLAN VARIABLES
#-----------------------------------------------------------------------------

variable "cloudbuild_sa_access_level_plan_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "cloudbuild_sa_access_level_plan_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL APPLY VARIABLES
#------------------------------------------------------------------------------

variable "cloudbuild_sa_access_level_apply_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "cloudbuild_sa_access_level_apply_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

#-------------------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL PLAN VARIABLES
#-------------------------------------------------------------

variable "admin_access_level_plan_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "admin_access_level_plan_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

#--------------------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL APPLY VARIABLES
#--------------------------------------------------------------

variable "admin_access_level_apply_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "admin_access_level_apply_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

#-------------------------------------------------------------
# CLOUDBUILD TRIGGERS - DEEP LEARNING VM IMAGE BUILD VARIABLES
#-------------------------------------------------------------

variable "deep_learning_vm_image_build_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "deep_learning_vm_image_build_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

variable "packer_project_id" {
  description = "The ID of the Packer project after it is provisioned."
  type        = string
  default     = ""
}

variable "packer_image_tag" {
  description = "The container image tag of Packer that was provisioned."
  type        = string
  default     = ""
}

#-----------------------------------------------------
# CLOUDBUILD TRIGGERS - bastion CIS IMAGE BUILD VARIABLES
#-----------------------------------------------------

variable "bastion_cis_image_build_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "bastion_cis_image_build_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

#-------------------------------------------------------
# CLOUDBUILD TRIGGERS - PACKER CONTAINER IMAGE VARIABLES
#-------------------------------------------------------

variable "packer_container_image_build_trigger_tags" {
  description = "Tags for annotation of a BuildTrigger"
  type        = list(string)
  default     = []
}

variable "packer_container_image_build_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}


#----------------------------
# FOLDER IAM MEMBER VARIABLES
#----------------------------

variable "iam_role_list" {
  description = "The IAM role(s) to assign to the member at the defined folder."
  type        = list(string)
  default     = []
}