variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "iam_role_name" {
  type    = string
  default = "IOTrole"
}
variable "assume_role_policy" {
  type    = string
}

variable "iam_policy_name" {
  type    = string
  default = null
}

variable "iam_policy" {
  type    = string
}

variable "permission_boundary" {
  type    = string
  default = null
}

variable "flag_use_existing_policy" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "existing_role_arn" {
  description = "The ARN of an existing IAM role."
  type        = string
  default     = null
}

variable "policy_count" {
  description = "Number of policies to attach to the IAM role"
  type        = number
  default     = 0
}

variable "existing_iam_policy_arns" {
  description = "The ARN of an existing IAM policy to be attached to the IAM role."
  type        = list(string)
  default     = ["xxxxxxx","xxxxxxxx"]
}
