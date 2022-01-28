#-----------------------------------
# PUB/SUB GCS NOTIFICATION VARIABLES
#-----------------------------------

// REQUIRED VARIABLES

variable "payload_format" {
  description = "The desired content of the Payload. One of `JSON_API_V1` or `NONE`."
  type        = string
  default     = ""
}

# variable "pub_sub_topic_name" {
#   description = "The name of the Pub Sub Topic that will have GCS notifications sent to."
#   type        = string
#   default     = ""
# }

// OPTIONAL VARIABLES

variable "custom_attributes" {
  description = "A set of key/value attribute pairs to attach to each Cloud PubSub message published for this notification subscription."
  type        = map(string)
  default     = {}
}

variable "event_types" {
  description = "List of event type filters for this notification configuration. If not specified, Cloud Storage will send notifications for all event types. The valid types are: `OBJECT_FINALIZE`, `OBJECT_METADATA_UPDATE`, `OBJECT_DELETE`, `OBJECT_ARCHIVE`."
  type        = list(string)
  default     = []
}

variable "object_name_prefix" {
  description = "Specifies a prefix path filter for this notification config. Cloud Storage will only send notifications for objects in this bucket whose names begin with the specified prefix."
  type        = string
  default     = null
}

#------------------------------------
# PUB/SUB TOPIC IAM MEMBER VARIABLES
#------------------------------------

// REQUIRED VARIABLES

# variable "project_id" {
#   description = "The Project ID that contains the Pub/Sub topic that will have a member and an IAM role applied to."
#   type        = string
#   default     = ""
# }

variable "topic_name" {
  description = "The Pub/Sub Topic name. Used to find the parent resource to bind the IAM policy to."
  type        = string
  default     = ""
}

variable "iam_member" {
  description = "The member that will have the defined IAM role applied to. Refer [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam) for syntax of members."
  type        = string
  default     = ""
}

variable "role" {
  description = "The IAM role to set for the member. Only one role can be set. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`"
  type        = string
  default     = ""
}