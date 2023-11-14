variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Cluster
################################################################################

variable "applications" {
  description = "A case-insensitive list of applications for Amazon EMR to install and configure when launching the cluster"
  type        = list(string)
  default     = []
}

variable "idle_timeout" {
  description = "Idle timeout for auto termination policy"
  type        = string
  default     = null
}

variable "bootstrap_action" {
  description = "Ordered list of bootstrap actions that will be run before Hadoop is started on the cluster nodes"
  type        = any
  default     = {}
}

variable "configurations" {
  description = "List of configurations supplied for the EMR cluster you are creating. Supply a configuration object for applications to override their default configuration"
  type        = string
  default     = null
}

variable "configurations_json" {
  description = "JSON string for supplying list of configurations for the EMR cluster"
  type        = string
  default     = null
}

variable "core_instance_group" {
  description = "Configuration block to use an [Instance Group] for the core node type"
  type        = any
  default     = {}
}

variable "custom_ami_id" {
  description = "Custom Amazon Linux AMI for the cluster (instead of an EMR-owned AMI). Available in Amazon EMR version 5.7.0 and later"
  type        = string
  default     = null
}

variable "ebs_root_volume_size" {
  description = "Size in GiB of the EBS root device volume of the Linux AMI that is used for each EC2 instance. Available in Amazon EMR version 4.x and later"
  type        = number
  default     = null
}

variable "ec2_attributes" {
  description = "Attributes for the EC2 instances running the job flow"
  type        = any
  default     = {}
}

variable "list_steps_states" {
  description = "List of [step states](https://docs.aws.amazon.com/emr/latest/APIReference/API_StepStatus.html) used to filter returned steps"
  type        = list(string)
  default     = []
}

variable "log_encryption_kms_key_id" {
  description = "AWS KMS customer master key (CMK) key ID or arn used for encrypting log files. This attribute is only available with EMR version 5.30.0 and later, excluding EMR 6.0.0"
  type        = string
  default     = null
}

variable "log_uri" {
  description = "S3 bucket to write the log files of the job flow. If a value is not provided, logs are not created"
  type        = string
  default     = null
}

variable "master_instance_group" {
  description = "Configuration block to use an [Instance Group](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-instance-group-configuration.html#emr-plan-instance-groups) for the [master node type](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html#emr-plan-master)"
  type        = any
  default     = {}
}

variable "name" {
  description = "Name of the job flow"
  type        = string
  default     = ""
}

variable "release_label" {
  description = "Release label for the Amazon EMR release"
  type        = string
  default     = null
}

variable "scale_down_behavior" {
  description = "Way that individual Amazon EC2 instances terminate when an automatic scale-in activity occurs or an instance group is resized"
  type        = string
  default     = "TERMINATE_AT_TASK_COMPLETION"
}

variable "step" {
  description = "Steps to run when creating the cluster"
  type        = any
  default     = {}
}

variable "step_concurrency_level" {
  description = "Number of steps that can be executed concurrently. You can specify a maximum of 256 steps. Only valid for EMR clusters with `release_label` 5.28.0 or greater (default is 1)"
  type        = number
  default     = null
}

variable "termination_protection" {
  description = "Switch on/off termination protection (default is `false`, except when using multiple master nodes). Before attempting to destroy the resource when termination protection is enabled, this configuration must be applied with its value set to `false`"
  type        = bool
  default     = null
}

################################################################################
# Task Instance Group
# Ref: https://github.com/hashicorp/terraform-provider-aws/issues/29668
################################################################################

variable "task_instance_group" {
  description = "Configuration block to use an [Instance Group](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-instance-group-configuration.html#emr-plan-instance-groups) for the [task node type](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html#emr-plan-master)"
  type        = any
  default     = {}
}

################################################################################
# Managed Scaling Policy
################################################################################

variable "managed_scaling_policy" {
  description = "Compute limit configuration for a [Managed Scaling Policy](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-scaling.html)"
  type        = any
  default     = {}
}

################################################################################
# Service IAM Role
################################################################################

variable "service_iam_role_arn" {
  description = "The ARN of an existing IAM role to use for the service"
  type        = string
  default     = null
}

################################################################################
# Autoscaling IAM Role
################################################################################

variable "autoscaling_iam_role_arn" {
  description = "The ARN of an existing IAM role to use for autoscaling"
  type        = string
  default     = null
}
