#----------------------------
# SRDE FOLDER POLICIES TFVARS
# For `srde_folder_define_trusted_image_projects` look into adding the
# google public project id for deep-learing
# Project ID: projects/deeplearning-platform-release 
#----------------------------

srde_folder_resource_location_restriction_allow       = ["in:us-locations"] // "US" is required to support BQ SQL joins with certain public datasets
srde_folder_restrict_shared_vpc_subnetwork_allow      = []
srde_folder_vms_allowed_ip_forwarding                 = []
srde_folder_disable_public_access_prevention_projects = [] # Buckets listed are allowed to be publicaly available