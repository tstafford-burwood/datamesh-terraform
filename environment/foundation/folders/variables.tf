variable "environment" {
  description = "Environment name."
  type        = string
}

variable "researcher_workspace_names" {
  description = "list of researcher workspace names"
  type        = list(string)
  default     = []
}

variable "suffix" {
  description = "folder name suffix"
  type        = string
  default     = "sde"
}