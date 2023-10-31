variable "enable_sagemaker_notebook_instance" {
  description = "Enable sagemaker notebook instance usage"
  default     = true
}

variable "sagemaker_notebook_instance_name" {
  description = "The name of the notebook instance (must be unique)."
  default     = "iotsagemaker"
}

variable "sagemaker_notebook_instance_role_arn" {
  description = "(Required) The ARN of the IAM role to be used by the notebook instance which allows SageMaker to call other services on your behalf."
  default     = "arn:aws:iam::064047601590:role/SagemakerEMRNoAuthProductWi-SageMakerExecutionRole-1KF4KOLT4YA6A"
}

variable "sagemaker_notebook_instance_instance_type" {
  description = "(Required) The name of ML compute instance type."
  default     = "ml.t2.medium"
}

variable "sagemaker_notebook_instance_subnet_id" {
  description = "(Optional) The VPC subnet ID."
  default     = null
}

variable "sagemaker_notebook_instance_security_groups" {
  description = "(Optional) The associated security groups."
  default     = null
}

variable "sagemaker_notebook_instance_kms_key_id" {
  description = "(Optional) The AWS Key Management Service (AWS KMS) key that Amazon SageMaker uses to encrypt the model artifacts at rest using Amazon S3 server-side encryption."
  default     = null
}

variable "sagemaker_notebook_instance_lifecycle_config_name" {
  description = "(Optional) The name of a lifecycle configuration to associate with the notebook instance."
  default     = null
}

variable "sagemaker_notebook_instance_direct_internet_access" {
  description = "(Optional) Set to Disabled to disable internet access to notebook. Requires security_groups and subnet_id to be set. Supported values: Enabled (Default) or Disabled. If set to Disabled, the notebook instance will be able to access resources only in your VPC, and will not be able to connect to Amazon SageMaker training and endpoint services unless your configure a NAT Gateway in your VPC."
  default     = null
}

variable "sagemaker_notebook_volume-size" {
  description = "(Optional) The size, in GB, of the ML storage volume to attach to the notebook instance. The default value is 5 GB"
  default = 5
}


variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "enable_sagemaker_notebook_instance_lifecycle_configuration" {
  description = "Enable sagemaker notebook instance lifecycle configuration usage"
  default     = false
}
