#-------------------------
# CLOUD COMPOSER VARIABLES
#-------------------------

variable "srde_project_vms_allowed_external_ip" {
  description = "This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE"
  type        = list(string)
  default     = []
}

// OPTIONAL

variable "allowed_ip_range" {
  description = "The IP ranges which are allowed to access the Apache Airflow Web Server UI."
  type = list(object({
    value       = string
    description = string
  }))
  default = []
}

variable "cloud_sql_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for Cloud SQL."
  type        = string
  default     = "10.4.0.0/24"
}

variable "database_machine_type" {
  description = "The machine type to setup for the SQL database in the Cloud Composer environment."
  type        = string
  default     = "db-n1-standard-4"
}

variable "disk_size" {
  description = "The disk size in GB for nodes."
  type        = string
  default     = "50"
}

variable "env_variables" {
  description = "Variables of the airflow environment."
  type        = map(string)
  default     = {}
}

variable "image_version" {
  description = "The version of Airflow running in the Cloud Composer environment. Latest version found [here](https://cloud.google.com/composer/docs/concepts/versioning/composer-versions)."
  type        = string
  default     = "composer-1.20.7-airflow-1.10.15"
}

variable "gke_machine_type" {
  description = "Machine type of Cloud Composer nodes."
  type        = string
  default     = "n1-standard-2"
}

variable "master_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for the master."
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of worker nodes in the Cloud Composer Environment."
  type        = number
  default     = 3
}

variable "oauth_scopes" {
  description = "Google API scopes to be made available on all node."
  type        = set(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "web_server_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for the web server."
  type        = string
  default     = "10.3.0.0/29"
}

variable "web_server_machine_type" {
  description = "The machine type to setup for the Apache Airflow Web Server UI."
  type        = string
  default     = "composer-n1-webserver-4"
}

variable "enforce" {
  description = "Whether this policy is enforced."
  type        = bool
  default     = true
}