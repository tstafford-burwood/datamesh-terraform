#-------------------------------------------
# STAGING PROJECT - INGRESS BUCKET VARIABLES
#-------------------------------------------

// REQUIRED VARIABLES

# variable "staging_ingress_bucket_suffix_name" {
#   description = "The suffix/ending name for the bucket."
#   type        = list(string)
# }

# variable "staging_ingress_bucket_prefix_name" {
#   description = "The prefix/beginning used to generate the bucket."
#   type        = string
# }


// OPTIONAL VARIABLES

variable "staging_ingress_bucket_set_admin_roles" {
  description = "Grant roles/storage.objectAdmin role to admins and bucket_admins."
  type        = bool
  default     = false
}

variable "staging_ingress_bucket_admins" {
  description = "IAM-style members who will be granted role/storage.objectAdmins for all buckets."
  type        = list(string)
  default     = []
}

# variable "staging_ingress_bucket_versioning" {
#   description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
#   type        = map
#   default     = {}
# }

variable "staging_ingress_bucket_creators" {
  description = "IAM-style members who will be granted roles/storage.objectCreators on all buckets."
  type        = list(string)
  default     = []
}

# variable "staging_ingress_bucket_encryption_key_names" {
#   description = "Optional map of lowercase unprefixed name => string, empty strings are ignored."
#   type        = map
#   default     = {}
# }

# variable "staging_ingress_bucket_folders" {
#   description = "Map of lowercase unprefixed name => list of top level folder objects."
#   type        = map
#   default     = {}
# }

# variable "staging_ingress_bucket_force_destroy" {
#   description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
#   type        = map
#   default     = {}
# }

# variable "staging_ingress_storage_bucket_labels" {
#   description = "Labels to be attached to the buckets"
#   type        = map
#   default     = {}
# }

# variable "staging_ingress_bucket_location" {
#   description = "Bucket location. See this link for regional and multi-regional options https://cloud.google.com/storage/docs/locations#legacy"
#   type        = string
#   default     = "US"
# }

# variable "staging_ingress_bucket_set_creator_roles" {
#   description = "Grant roles/storage.objectCreator role to creators and bucket_creators."
#   type        = bool
#   default     = false
# }

# variable "staging_ingress_bucket_set_viewer_roles" {
#   description = "Grant roles/storage.objectViewer role to viewers and bucket_viewers."
#   type        = bool
#   default     = false
# }

# variable "staging_ingress_bucket_storage_class" {
#   description = "Bucket storage class. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
#   type        = string
#   default     = "STANDARD"
# }

variable "staging_ingress_bucket_viewers" {
  description = "IAM-style members who will be granted roles/storage.objectViewer on all buckets."
  type        = list(string)
  default     = []
}

#------------------------------------------------
# DATA LAKE - INGRESS BUCKET VARIABLES
#------------------------------------------------

// REQUIRED VARIABLES

# variable "data_lake_bucket_suffix_name" {
#   description = "The suffix/ending name for the bucket."
#   type        = list(string)
# }

# variable "data_lake_ingress_bucket_prefix_name" {
#   description = "The prefix/beginning used to generate the bucket."
#   type        = string
# }


// OPTIONAL VARIABLES

variable "data_lake_ingress_bucket_set_admin_roles" {
  description = "Grant roles/storage.objectAdmin role to admins and bucket_admins."
  type        = bool
  default     = false
}

variable "data_lake_ingress_bucket_admins" {
  description = "IAM-style members who will be granted role/storage.objectAdmins for all buckets."
  type        = list(string)
  default     = []
}

# variable "data_lake_ingress_bucket_versioning" {
#   description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
#   type        = map
#   default     = {}
# }

variable "data_lake_ingress_bucket_creators" {
  description = "IAM-style members who will be granted roles/storage.objectCreators on all buckets."
  type        = list(string)
  default     = []
}

# variable "data_lake_ingress_bucket_encryption_key_names" {
#   description = "Optional map of lowercase unprefixed name => string, empty strings are ignored."
#   type        = map
#   default     = {}
# }

# variable "data_lake_ingress_bucket_folders" {
#   description = "Map of lowercase unprefixed name => list of top level folder objects."
#   type        = map
#   default     = {}
# }

# variable "data_lake_ingress_bucket_force_destroy" {
#   description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
#   type        = map
#   default     = {}
# }

# variable "data_lake_ingress_storage_bucket_labels" {
#   description = "Labels to be attached to the buckets"
#   type        = map
#   default     = {}
# }

# variable "data_lake_ingress_bucket_location" {
#   description = "Bucket location. See this link for regional and multi-regional options https://cloud.google.com/storage/docs/locations#legacy"
#   type        = string
#   default     = "US"
# }

# variable "data_lake_ingress_bucket_set_creator_roles" {
#   description = "Grant roles/storage.objectCreator role to creators and bucket_creators."
#   type        = bool
#   default     = false
# }

# variable "data_lake_ingress_bucket_set_viewer_roles" {
#   description = "Grant roles/storage.objectViewer role to viewers and bucket_viewers."
#   type        = bool
#   default     = false
# }

# variable "data_lake_ingress_bucket_storage_class" {
#   description = "Bucket storage class. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
#   type        = string
#   default     = "STANDARD"
# }

variable "data_lake_ingress_bucket_viewers" {
  description = "IAM-style members who will be granted roles/storage.objectViewer on all buckets."
  type        = list(string)
  default     = []
}