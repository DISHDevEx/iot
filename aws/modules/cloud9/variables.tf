variable "region" {
  description = "The region of the environment."
  type        = string
  default     = null
}

################################################################################
# Cloud9 environment
################################################################################

variable "name" {
  description = "The name of the environment."
  type        = string
  default     = "this"
}

variable "instance_type" {
  description = "The type of instance to connect to the environment."
  type        = string
  default     = "t2.micro"
}

variable "automatic_stop_time_minutes" {
  description = "The number of minutes until the running instance is shut down after the environment has last been used."
  type        = number
  default     = 30
}

variable "connection_type" {
  description = "The connection type used for connecting to an Amazon EC2 environment. Valid values are CONNECT_SSH and CONNECT_SSM."
  type        = string
  default     = "CONNECT_SSM"
}

variable "description" {
  description = "The description of the environment."
  type        = string
  default     = null
}

variable "image_id" {
  description = <<EOF
                The identifier for the Amazon Machine Image (AMI) that's used to create the EC2 instance. Valid values are
                amazonlinux-1-x86_64, amazonlinux-2-x86_64, ubuntu-18.04-x86_64, ubuntu-22.04-x86_64,
                resolve:ssm:/aws/service/cloud9/amis/amazonlinux-1-x86_64, resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2-x86_64,
                resolve:ssm:/aws/service/cloud9/amis/ubuntu-18.04-x86_64, resolve:ssm:/aws/service/cloud9/amis/ubuntu-22.04-x86_64 
                EOF
  type        = string
  default     = "amazonlinux-2-x86_64"
}

variable "owner_arn" {
  description = "The ARN of the environment owner. This can be ARN of any AWS IAM principal. Defaults to the environment's creator."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The ID of the subnet in Amazon VPC that AWS Cloud9 will use to communicate with the Amazon EC2 instance."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

################################################################################
# Cloud9 environment membership
################################################################################

variable "create_membership" {
  description = "Cloud9 membership is created or not."
  type        = bool
  default     = false
}

variable "permissions" {
  description = "The type of environment member permissions you want to associate with this environment member. Allowed values are read-only and read-write."
  type        = string
  default     = "read-only"
}

variable "user_arn" {
  description = "The Amazon Resource Name (ARN) of the environment member you want to add."
  type        = string
  default     = ""
}
