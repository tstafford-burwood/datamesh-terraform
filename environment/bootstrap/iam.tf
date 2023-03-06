module "folder-iam-admins" {
  # Project level roles
  source        = "../../modules/iam/folder_iam"
  folder_id     = google_folder.parent.id
  folder_member = "serviceAccount:${var.cloudbuild_service_account}"
  iam_role_list = var.cloudbuild_iam_roles
}

resource "google_organization_iam_member" "policy_admin" {
  org_id = var.org_id
  role   = "roles/orgpolicy.policyAdmin"
  member = "serviceAccount:${var.cloudbuild_service_account}"
}

resource "google_billing_account_iam_member" "billing_user" {
  billing_account_id = var.billing_account_id
  role               = "roles/billing.user"
  member             = "serviceAccount:${var.cloudbuild_service_account}"
}

# --------------------------------------------------
# VARIABLES
# --------------------------------------------------

variable "cloudbuild_iam_roles" {
  description = "The IAM role(s) to assign to the `Admins` at the defined project."
  type        = list(string)
  default = [
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
  ]
}

variable "cloudbuild_service_account" {
  description = "Cloud Build Service Account"
  type        = string
}

variable "billing_account_id" {
  description = "Billing account."
  type        = string
}