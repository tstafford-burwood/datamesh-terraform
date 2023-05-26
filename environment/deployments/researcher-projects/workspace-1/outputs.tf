output "notebook_sa_member" {
  # tfdoc:output:consumers foundation/vpc-sc
  description = "Notebook service account identity in the form `serviceAccount:{email}`"
  value       = module.workspace_1.notebook_sa_member
}