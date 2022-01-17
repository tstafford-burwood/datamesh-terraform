#-------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM MEMBER BINDING TFVARS
#-------------------------------------------------------

workspace_project_member = "user:dspeck@sde.burwood.io" // UPDATE WITH RESEARCH GOOGLE GROUP TO ALLOW SSH FROM BASTION TO WORKSPACE VM

#------------------------------------------------------
# RESEARCHER BASTION PROJECT IAM MEMBER BINDING TFVARS
#------------------------------------------------------

bastion_project_member = "user:dspeck@sde.burwood.io" // UPDATE WITH RESEARCH GOOGLE GROUP TO ALLOW SSH INTO BASTION

#----------------------------------------
# STAGING PROJECT - INGRESS BUCKET TFVARS
#----------------------------------------

staging_ingress_bucket_admins = ["user:dspeck@sde.burwood.io"] // DATA STEWARDS IN RESEARCH GROUP; CHANGE WITH EACH NEW PROJECT

#----------------------------------------
# STAGING PROJECT - EGRESS BUCKET TFVARS
#----------------------------------------

staging_egress_bucket_viewers = ["user:dspeck@sde.burwood.io"] // DATA STEWARDS IN RESEARCH GROUP; CHANGE WITH EACH NEW PROJECT

#----------------------------------------------------
# VPC SC RESEARCHER GROUP MEMBER ACCESS LEVELS TFVARS
#----------------------------------------------------

access_level_name    = "group2_access_level_wcm_aaron"
access_level_members = ["user:dspeck@sde.burwood.io"]

#-----------------------------------------------------
# RESEARCHER WORKSPACE VPC SC REGULAR PERIMETER TFVARS
#-----------------------------------------------------

researcher_workspace_regular_service_perimeter_name                       = "group2_workspace_regular_service_perimeter_aaron" // CHANGE WITH EACH NEW PROJECT
researcher_workspace_regular_service_perimeter_egress_policies_identities = ["user:dspeck@sde.burwood.io"]

#----------------------------------------------------------------------
# RESEARCHER WORKSPACE & STAGING PROJECT VPC SC BRIDGE PERIMETER TFVARS 
#----------------------------------------------------------------------

workspace_and_staging_bridge_service_perimeter_name = "group2_workspace_staging_project_bridge_aaron" // CHANGE WITH EACH NEW PROJECT

#----------------------------------------------------------------------
# RESEARCHER WORKSPACE & DATA LAKE PROJECT VPC SC BRIDGE PERIMETER TFVARS 
#----------------------------------------------------------------------

workspace_and_data_lake_bridge_service_perimeter_name = "group2_workspace_data_lake_bridge_aaron" // CHANGE WITH EACH NEW PROJECT

#-----------------------------------------------------------
# RESEARCHER BASTION PROJECT VPC SC REGULAR PERIMETER TFVARS
#-----------------------------------------------------------

researcher_bastion_project_regular_service_perimeter_name = "group2_bastion_service_perimeter_aaron" // CHANGE WITH EACH NEW PROJECT

#----------------------------------------------------------------
# RESEARCHER EXTERNAL DATA EGRESS VPC SC REGULAR PERIMETER TFVARS
#----------------------------------------------------------------

researcher_data_egress_regular_service_perimeter_name = "group2_external_egress_perimeter_aaron" // CHANGE WITH EACH NEW PROJECT

#----------------------------------------------------------------------------
# RESEARCHER EXTERNAL EGRESS & STAGING PROEJCT VPC SC BRIDGE PERIMETER TFVARS
#---------------------------------------------------------------------------- 

external_egress_and_staging_bridge_service_perimeter_name = "group2_egress_staging_project_bridge_aaron" // CHANGE WITH EACH NEW PROJECT