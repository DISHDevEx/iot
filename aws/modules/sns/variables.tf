#############
## SNS Topic
#############
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "sns_topic_name" {
  description = "Name for the sns topic"
  type        = string
}

variable "sns_topic_name_prefix" {
  description = "Prefix to be added to the resource name"
  default     = "iot-"
}

variable "display_name" {
  description = "The display name to use for a topic with SMS subscriptions."
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "The policy that defines how Amazon SNS retries failed deliveries to HTTP/S endpoints."
  type        = string
  default     = null
}

variable "application_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic"
  type        = string
  default     = null
}

variable "application_failure_feedback_role_arn" {
  description = "IAM role for failure feedback"
  type        = string
  default     = null
}

variable "tracing_config" {
  description = "Tracing mode of an Amazon SNS topic. Valid values: PassThrough, Active."
  type        = string
  default     = null
}

variable "fifo_topic" {
  description = "indicating whether or not to create a FIFO (first-in-first-out) topic "
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO topics. "
  type        = bool
  default     = false
}

variable "lambda_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic"
  type        = string
  default     = null
}

variable "lambda_failure_feedback_role_arn" {
  description = "IAM role for failure feedback"
  type        = string
  default     = null
}

variable "sqs_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic"
  type        = string
  default     = null
}

variable "sqs_failure_feedback_role_arn" {
  description = "IAM role for failure feedback"
  type        = string
  default     = null
}

variable "firehose_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic"
  type        = string
  default     = null
}

variable "firehose_failure_feedback_role_arn" {
  description = "IAM role for failure feedback"
  type        = string
  default     = null
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK"
  type        = string
  default     = null
}

#########################
## SNS Topic Subscription
#########################

variable "endpoint" {
  description = "Endpoint to send data to. The contents vary with the protocol."
  type        = string
  sensitive   = true
}

variable "protocol" {
  description = "Protocol to use. Valid values are: sqs, sms, lambda, email, firehose, and application"
  type        = string
}

variable "subscription_role_arn" {
  description = "Required if protocol is firehose. ARN of the IAM role to publish to Kinesis Data Firehose delivery stream."
  type        = string
  default     = null
  sensitive   = true
}

variable "topic_arn" {
  description = "ARN of the SNS topic to subscribe to. "
  type        = string
  sensitive   = true
}

variable "filter_policy" {
  description = "JSON String with the filter policy that will be used in the subscription to filter messages seen by the target resource. "
  type        = string
  default     = null
}

variable "filter_policy_scope" {
  description = "Whether the filter_policy applies to MessageAttributes (default) or MessageBody "
  type        = string
  default     = null
}

variable "confirmation_timeout" {
  description = "Integer indicating number of minutes to wait in retrying mode for fetching subscription arn before marking it as failure. Only applicable for http and https protocols. "
  type        = number
  default     = 1
}

