#----------------------------
# SRDE FOLDER POLICIES TFVARS
# For `srde_folder_define_trusted_image_projects` look into adding the
# google public project id for deep-learing
# Project ID: projects/deeplearning-platform-release 
#----------------------------

srde_folder_domain_restricted_sharing_allow = ["C03g5ccaa"] # gcloud organizations list --format="value(DIRECTORY_CUSTOMER_ID)"