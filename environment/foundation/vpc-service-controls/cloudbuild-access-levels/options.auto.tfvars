// OPTIONAL TFVARS - NON PREMIUM

combining_function       = "OR"
access_level_description = "Cloudbuild Service Account Access Level for Terraform operations from automation-aaron-2 project" // CHANGE BEFORE FIRST DEPLOYMENT
ip_subnetworks           = []
negate                   = false
regions                  = []
required_access_levels   = []

// OPTIONAL TFVARS - DEVICE POLICY (PREMIUM)

allowed_device_management_levels = []
allowed_encryption_statuses      = []
minimum_version                  = ""
os_type                          = "OS_UNSPECIFIED"
require_corp_owned               = false
require_screen_lock              = false