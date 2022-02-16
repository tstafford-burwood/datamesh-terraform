researcher_workspace_name     = "group3"
environment                   = "dev"
#bastion_project_member        = "user:dspeck@sde.burwood.io"   // UPDATE WITH RESEARCH GOOGLE GROUP TO ALLOW SSH INTO BASTION
workspace_project_member      = "user:dspeck@sde.burwood.io"   // UPDATE WITH RESEARCH GOOGLE GROUP TO ALLOW SSH FROM BASTION TO WORKSPACE VM
#staging_ingress_bucket_admins = ["user:dspeck@sde.burwood.io"] // DATA STEWARDS IN RESEARCH GROUP; CHANGE WITH EACH NEW PROJECT
#staging_egress_bucket_viewers = ["user:dspeck@sde.burwood.io"] // DATA STEWARDS IN RESEARCH GROUP; CHANGE WITH EACH NEW PROJECT

activate_apis = [
    "aiplatform.googleapis.com",
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "oslogin.googleapis.com",
    "iap.googleapis.com",
    "bigquery.googleapis.com",
    "dns.googleapis.com",
    "notebooks.googleapis.com",
    "osconfig.googleapis.com",
    "monitoring.googleapis.com"
]

#workspace_artifact_registry_cloud_dns_domain = "us-central1.gcr.io"
#workspace_artifact_registry_cloud_dns_name = "us-central1-gcr-io"
