researcher_workspace_name     = "group2"
environment                   = "dev"
bastion_project_member        = "user:dspeck@sde.burwood.io"   // UPDATE WITH RESEARCH GOOGLE GROUP TO ALLOW SSH INTO BASTION
workspace_project_member      = "user:dspeck@sde.burwood.io"   // UPDATE WITH RESEARCH GOOGLE GROUP TO ALLOW SSH FROM BASTION TO WORKSPACE VM
staging_ingress_bucket_admins = ["user:dspeck@sde.burwood.io"] // DATA STEWARDS IN RESEARCH GROUP; CHANGE WITH EACH NEW PROJECT
staging_egress_bucket_viewers = ["user:dspeck@sde.burwood.io"] // DATA STEWARDS IN RESEARCH GROUP; CHANGE WITH EACH NEW PROJECT
num_instances_deeplearing_vms = 1

num_instances_researcher_bastion_vms = 1
