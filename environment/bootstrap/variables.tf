variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "project_id" {
  description = "The Google Project ID to host the bucket."
  type        = string
  default     = "github-actions-demos"
}

variable "location" {
  description = "The location of place the bucket"
  type        = string
  default     = "us-central1"
}