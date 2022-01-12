#------------------------------
# SRDE FOLDER POLICY VARIABLES
#------------------------------

variable "srde_folder_resource_location_restriction_allow" {
  description = "This list constraint defines the set of locations where location-based GCP resources can be created in for the SRDE folder."
  type        = list(string)
  default     = []
}

variable "srde_folder_domain_restricted_sharing_allow" {
  description = "This list constraint defines the set of members that can be added to Cloud IAM policies in the SRDE folder."
  type        = list(string)
  default     = []
}

variable "srde_folder_restrict_shared_vpc_subnetwork_allow" {
  description = "This list constraint defines the set of shared VPC subnetworks that eligible resources can use. The allowed/denied list of subnetworks must be specified in the form: under:organizations/ORGANIZATION_ID, under:folders/FOLDER_ID, under:projects/PROJECT_ID, or projects/PROJECT_ID/regions/REGION/subnetworks/SUBNETWORK-NAME."
  type        = list(string)
  default     = []
}

variable "srde_folder_vms_allowed_external_ip" {
  description = "This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE"
  type        = list(string)
  default     = []
}

variable "srde_folder_vms_allowed_ip_forwarding" {
  description = "Identify VM instance name in format : projects/PROJECT_ID, or projects/PROJECT_ID/zones/ZONE/instances/INSTANCE-NAME."
  type        = list(string)
  default     = []
}

variable "srde_folder_define_trusted_image_projects" {
  description = "This list constraint defines the set of projects that can be used for image storage and disk instantiation for Compute Engine. The allowed/denied list of publisher projects must be strings in the form: projects/PROJECT_ID. If this constraint is active, only images from trusted projects will be allowed as the source for boot disks for new instances."
  type        = list(string)
  default     = []
}

variable "srde_folder_disable_public_access_prevention_projects" {
  description = "Define projects where GCS buckets can be opened to public access for allUsers or allAuthenticatedUsers."
  type        = list(string)
  default     = []
}