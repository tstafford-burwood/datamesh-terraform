#----------------------------
# VPC SC ACCESS LEVELS TFVARS
#----------------------------
// OPTIONAL TFVARS - NON PREMIUM

combining_function       = "OR"
access_level_description = "SRDE Admin Group Members VPC SC Access Level"
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