#---------------------------------
# SECURE STAGING PROJECT VARIABLES
#---------------------------------

variable "environment" {
  description = "Environment name."
  type        = string
}


// REQUIRED VARIABLES

# variable "project_name" {
#   description = "The name for the project"
#   type        = string
#   default     = ""
# }


// OPTIONAL VARIABLES

# variable "activate_apis" {
#   description = "The list of apis to activate within the project"
#   type        = list(string)
#   default     = ["compute.googleapis.com"]
# }

# variable "auto_create_network" {
#   description = "Create the default network"
#   type        = bool
#   default     = false
# }

# variable "create_project_sa" {
#   description = "Whether the default service account for the project shall be created"
#   type        = bool
#   default     = true
# }

variable "default_service_account" {
  description = "Project compute engine default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
  type        = string
  default     = "keep"
}

# variable "disable_dependent_services" {
#   description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed."
#   type        = bool
#   default     = true
# }

# variable "disable_services_on_destroy" {
#   description = "Whether project services will be disabled when the resources are destroyed"
#   type        = string
#   default     = "true"
# }

# variable "group_name" {
#   description = "A Google group to control the project by being assigned group_role (defaults to project viewer)"
#   type        = string
#   default     = ""
# }

# variable "group_role" {
#   description = "The role to give the controlling group (group_name) over the project (defaults to project viewer)"
#   type        = string
#   default     = "roles/viewer"
# }

# variable "project_labels" {
#   description = "Map of labels for project"
#   type        = map(string)
#   default     = {}
# }

# variable "lien" {
#   description = "Add a lien on the project to prevent accidental deletion"
#   type        = bool
#   default     = false
# }

# variable "random_project_id" {
#   description = "Adds a suffix of 4 random characters to the `project_id`"
#   type        = bool
#   default     = true
# }

#-------------------------
# STANDALONE VPC VARIABLES
#-------------------------

# variable "vpc_network_name" {
#   description = "The name of the network being created"
#   type        = string
# }

# variable "auto_create_subnetworks" {
#   description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
#   type        = bool
#   default     = false
# }

# variable "delete_default_internet_gateway_routes" {
#   description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
#   type        = bool
#   default     = false
# }

# variable "firewall_rules" {
#   description = "List of firewall rules"
#   type        = any
#   default     = []
# }

# variable "routing_mode" {
#   description = "The network routing mode for regional dynamic routing or global dynamic routing (default 'GLOBAL' otherwise use 'REGIONAL')"
#   type        = string
#   default     = "GLOBAL"
# }

# variable "vpc_description" {
#   description = "An optional description of this resource. The resource must be recreated to modify this field."
#   type        = string
#   default     = "VPC created from Terraform for web app use case deployment."
# }

# variable "shared_vpc_host" {
#   description = "Makes this project a Shared VPC host if 'true' (default 'false')"
#   type        = bool
#   default     = false
# }

# variable "mtu" {
#   type        = number
#   description = "The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically."
# }

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default = [
    {
      subnet_name               = "subnet-01"
      subnet_ip                 = "10.0.0.0/16"
      subnet_region             = "us-central1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access     = "true"
    }
  ]
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default = {
    subnet-01 = [
      {
        range_name    = "kubernetes-pods"
        ip_cidr_range = "10.1.0.0/20"
      },
      {
        range_name    = "kubernetes-services"
        ip_cidr_range = "10.2.0.0/24"
      }
    ]
  }
}

variable "routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC. For more information see [link](https://github.com/terraform-google-modules/terraform-google-network#route-inputs)"
  default     = []
}

#-------------------------
# PUB/SUB TOPIC VARIABLES
#-------------------------

// REQUIRED VARIABLES

# variable "topic_name" {
#   description = "Name of the topic."
#   type        = string
#   default     = ""
# }

# variable "allowed_persistence_regions" {
#   description = "A list of IDs of GCP regions where messages that are published to the topic may be persisted in storage. Messages published by publishers running in non-allowed GCP regions (or running outside of GCP altogether) will be routed for storage in one of the allowed regions. An empty list means that no regions are allowed, and is not a valid configuration."
#   type        = list(string)
# }

// OPTIONAL VARIABLES

variable "kms_key_name" {
  description = "The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic. Your project's PubSub service account `(service-{{PROJECT_NUMBER}}@gcp-sa-pubsub.iam.gserviceaccount.com)` must have `roles/cloudkms.cryptoKeyEncrypterDecrypter` to use this feature. The expected format is `projects/*/locations/*/keyRings/*/cryptoKeys/*`"
  type        = string
  default     = null
}

# variable "topic_labels" {
#   description = "A set of key/value label pairs to assign to this Topic."
#   type        = map(string)
#   default     = {}
# }

#-------------------------------
# PUB/SUB SUBSCRIPTION VARIABLES
#-------------------------------

// REQUIRED VARIABLES

# variable "subscription_name" {
#   description = "Name of the subscription."
#   type        = string
#   default     = ""
# }

# variable "project_id" {
#   description = "The ID of the project in which the resource belongs."
#   type        = string
#   default     = ""
# }

# variable "subscription_topic_name" {
#   description = "The name of the topic to reference and associate this subscription with."
#   type        = string
#   default     = ""
# }

# // OPTIONAL VARIABLES

# variable "ack_deadline_seconds" {
#   description = "This value is the maximum time after a subscriber receives a message before the subscriber should acknowledge the message. After message delivery but before the ack deadline expires and before the message is acknowledged, it is an outstanding message and will not be delivered again during that time (on a best-effort basis). For pull subscriptions, this value is used as the initial value for the ack deadline. To override this value for a given message, call subscriptions.modifyAckDeadline with the corresponding ackId if using pull. The minimum custom deadline you can specify is 10 seconds. The maximum custom deadline you can specify is 600 seconds (10 minutes). If this parameter is 0, a default value of 10 seconds is used. For push delivery, this value is also used to set the request timeout for the call to the push endpoint. If the subscriber never acknowledges the message, the Pub/Sub system will eventually redeliver the message."
#   type        = number
#   default     = 10
# }

# variable "audience" {
#   description = "Audience to be used when generating OIDC token. The audience claim identifies the recipients that the JWT is intended for. The audience value is a single case-sensitive string. Having multiple values (array) for the audience field is not supported. More info about the OIDC JWT token audience [here](https://tools.ietf.org/html/rfc7519#section-4.1.3). Note: if not specified, the Push endpoint URL will be used."
#   type        = string
#   default     = null
# }

# variable "dead_letter_topic" {
#   description = "The name of the topic to which dead letter messages should be published. Format is projects/{project}/topics/{topic}. The Cloud Pub/Sub service account associated with the enclosing subscription's parent project (i.e., service-{project_number}@gcp-sa-pubsub.iam.gserviceaccount.com) must have permission to Publish() to this topic. The operation will fail if the topic does not exist. Users should ensure that there is a subscription attached to this topic since messages published to a topic with no subscriptions are lost."
#   type        = string
#   default     = null
# }

# variable "enable_message_ordering" {
#   description = "If `true`, messages published with the same orderingKey in PubsubMessage will be delivered to the subscribers in the order in which they are received by the Pub/Sub system. Otherwise, they may be delivered in any order."
#   type        = bool
#   default     = true
# }

# variable "expiration_policy_ttl" {
#   description = "Specifies the `time-to-live` duration for an associated resource. The resource expires if it is not active for a period of ttl. If ttl is not set, the associated resource never expires. A duration in seconds with up to nine fractional digits, terminated by 's'. Example - `3.5s`."
#   type        = string
#   default     = ""
# }

# variable "filter" {
#   description = "The subscription only delivers the messages that match the filter. Pub/Sub automatically acknowledges the messages that don't match the filter. You can filter messages by their attributes. The maximum length of a filter is 256 bytes. After creating the subscription, you can't modify the filter."
#   type        = number
#   default     = null
# }

# variable "maximum_backoff" {
#   description = "The maximum delay between consecutive deliveries of a given message. Value should be between 0 and 600 seconds. Defaults to 600 seconds. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: `3.5`."
#   type        = number
#   default     = null
# }

# variable "minimum_backoff" {
#   description = "The minimum delay between consecutive deliveries of a given message. Value should be between 0 and 600 seconds. Defaults to 10 seconds. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: `3.5s`."
#   type        = number
#   default     = null
# }

# variable "max_delivery_attempts" {
#   description = "The maximum number of delivery attempts for any message. The value must be between 5 and 100. The number of delivery attempts is defined as 1 + (the sum of number of NACKs and number of times the acknowledgement deadline has been exceeded for the message). A NACK is any call to ModifyAckDeadline with a 0 deadline. Note that client libraries may automatically extend ack_deadlines. This field will be honored on a best effort basis. If this parameter is 0, a default value of 5 is used."
#   type        = number
#   default     = null
# }

# variable "message_retention_duration" {
#   description = "How long to retain unacknowledged messages in the subscription's backlog, from the moment a message is published. If retainAckedMessages is true, then this also configures the retention of acknowledged messages, and thus configures how far back in time a subscriptions.seek can be done. Defaults to 7 days. Cannot be more than 7 days (`604800s`) or less than 10 minutes (`600s`). A duration in seconds with up to nine fractional digits, terminated by 's'. Example: `600.5s`."
#   type        = number
#   default     = null
# }

# variable "push_endpoint" {
#   description = "A URL locating the endpoint to which messages should be pushed. For example, a Webhook endpoint might use `https://example.com/push`."
#   type        = string
#   default     = ""
# }

# variable "push_attributes" {
#   description = "Endpoint configuration attributes. Every endpoint has a set of API supported attributes that can be used to control different aspects of the message delivery. The currently supported attribute is x-goog-version, which you can use to change the format of the pushed message. This attribute indicates the version of the data expected by the endpoint. This controls the shape of the pushed message (i.e., its fields and metadata). The endpoint version is based on the version of the Pub/Sub API. If not present during the subscriptions.create call, it will default to the version of the API used to make such call. If not present during a subscriptions.modifyPushConfig call, its value will not be changed. subscriptions.get calls will always return a valid version, even if the subscription was created without this attribute. The possible values for this attribute are: [v1beta1] - uses the push format defined in the v1beta1 Pub/Sub API OR [v1 or v1beta2] - uses the push format defined in the v1 Pub/Sub API."
#   type        = map(string)
#   default     = {}
# }

# variable "retain_acked_messages" {
#   description = "Indicates whether to retain acknowledged messages. If `true`, then messages are not expunged from the subscription's backlog, even if they are acknowledged, until they fall out of the messageRetentionDuration window."
#   type        = bool
#   default     = false
# }

# variable "service_account_email" {
#   description = " Service account email to be used for generating the OIDC token. The caller (for subscriptions.create, subscriptions.patch, and subscriptions.modifyPushConfig RPCs) must have the iam.serviceAccounts.actAs permission for the service account."
#   type        = string
#   default     = ""
# }

# variable "subscription_labels" {
#   description = "A set of key/value label pairs to assign to this Subscription."
#   type        = map(string)
#   default     = {}
# }

#------------------------------------
# PUB/SUB TOPIC IAM MEMBER VARIABLES
#------------------------------------

// REQUIRED VARIABLES

# variable "iam_member" {
#   description = "The member that will have the defined IAM role applied to. Refer [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam) for syntax of members."
#   type        = string
#   default     = ""
# }

# variable "role" {
#   description = "The IAM role to set for the member. Only one role can be set. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`"
#   type        = string
#   default     = "roles/pubsub.publisher"
# }

#----------------------------------------------------
# FOLDER IAM MEMBER VARIABLES - DLP API SERVICE AGENT
#----------------------------------------------------

variable "dlp_service_agent_iam_role_list" {
  description = "The IAM role(s) to assign to the member at the defined folder."
  type        = list(string)
  default     = ["roles/dlp.jobsEditor"]
}

#------------------------------------------
# STAGING PROJECT IAM CUSTOM ROLE VARIABLES
#------------------------------------------

# variable "project_iam_custom_role_project_id" {
#   description = "The project that the custom role will be created in. Defaults to the provider project configuration."
#   type        = string
#   default     = ""
# }

# variable "project_iam_custom_role_description" {
#   description = "A human-readable description for the role."
#   type        = string
#   default     = "Custom role created with Terraform."
# }

variable "project_iam_custom_role_id" {
  description = "The camel case role id to use for this role. Cannot contain - characters."
  type        = string
  default     = "sreCustomRoleStorageBucketsList"
}

# variable "project_iam_custom_role_title" {
#   description = "A human-readable title for the role."
#   type        = string
#   default     = ""
# }

variable "project_iam_custom_role_permissions" {
  description = "The names of the permissions this role grants when bound in an IAM policy. At least one permission must be specified."
  type        = list(string)
  default     = ["storage.buckets.list"]
}

variable "project_iam_custom_role_stage" {
  description = "The current launch stage of the role. Defaults to GA. List of possible stages is [here](https://cloud.google.com/iam/docs/reference/rest/v1/organizations.roles#Role.RoleLaunchStage)."
  type        = string
  default     = "GA"
}

#---------------------------------------------
# DATA STEWARDS - PROJECT IAM MEMBER VARIABLES
#---------------------------------------------

variable "data_stewards_iam_staging_project" {
  description = "The list of Data Stewards that will be assigned IAM roles on the Secure Staging Project."
  type        = list(string)
  #default     = []
}