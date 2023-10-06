
variable "filepath" {
  description = "Path to the Lambda function deployment package."
  type        = string
  default     = null
}

variable "resource_prefix" {
  description = "Prefix to be added to the resource name"
  default     = "iot-"
}

variable "lambda_function_name" {
  description = "Name for the Lambda function."
  type        = string
}

variable "flag_use_existing_role" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "existing_role_arn" {
  description = "The ARN of an existing IAM role to use for the Lambda function."
  type        = string
  default     = null
}

variable "lambda_role_name" {
  description = "Name of the Lambda Role name."
  type        = string
  default     = null
}

variable "handler" {
  description = "Lambda function handler."
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda function runtime."
  type        = string
  default     = "python3.8"
}
