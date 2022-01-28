environment             = "prod"
datalake_project_member = "srde-datagroup@prorelativity.com"    


# #---------------------------------------------------
# # DATA LAKE PROJECT TFVARS
# #--------------------------------------------------- 

# data_lake_project_name = "aaron3-"

# #---------------------------------------------------
# # DATA LAKE IAM MEMBER TFVARS
# # Recommendation is to use a Google Group
# #---------------------------------------------------

# datalake_project_member = "group:srde-datagroup@prorelativity.com" # Update w/ new group name

# #---------------------------------------------------
# # STAGING PROJECT - INGRESS BUCKET TFVARS
# #---------------------------------------------------

# staging_ingress_bucket_admins = ["group:srde-datagroup@prorelativity.com"] // DATA STEWARDS IN RESEARCH GROUP; CHANGE WITH EACH NEW PROJECT

# #---------------------------------------------------
# # VPC SC REGULAR PERIMETER - DATA LAKE TFVARS
# #---------------------------------------------------

# datalake_regular_service_perimeter_name = "aaron3_data_lake_perimeter"

# #---------------------------------------------------
# # VPC SC ACCESS LEVELS TFVARS
# # Currently only users and service accounts are supported
# # Creates the Access Context Manager and adds accounts
# #---------------------------------------------------

# datalake_access_level_name    = "aaron3_datalake_access_level"
# datalake_access_level_members = ["user:datasteward@prorelativity.com", "user:astrong@prorelativity.com"]

# #---------------------------------------------------
# # VPC SC DATALAKE TO STAGING BRIDGE PERIMETER TFVARS
# # Builds a bridge between two VPC Service Perimeters
# #---------------------------------------------------

# datalake_bridge_service_perimeter_name = "aaron3_datalake_to_staging_project_bridge"