
variable "filepath" {
  description = "Path to the Lambda function deployment package."
  type        = string
  default     = null
}

variable "function_name" {
  description = "Name for the Lambda function."
  type        = string
  default     = "IOT_Lambda_Template"
}

variable "role_arn" {
  description = "ARN of the IAM role for the Lambda function."
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
