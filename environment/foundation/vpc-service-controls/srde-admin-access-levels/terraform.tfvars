#----------------------------
# VPC SC ACCESS LEVELS TFVARS
# Can only use individuals, no Google Groups
#---------------------------- 

access_level_name = "admin_users" // CHANGE BEFORE FIRST DEPLOYMENT
access_level_members = [
    "user:astrong@burwood.com",
    "user:janderson@burwood.com",
    "user:dspeck@burwood.com",
    "user:dspeck@sde.burwood.io"
] // CHANGE AS NEEDED