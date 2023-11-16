
variable "step_function_name" {
  description = "Name for the Step Function"
  type        = string
}

variable "step_function_cloudwatch_log" {
  description = "Name for the Step Function Log Group"
  type        = string
}

variable "state_machine_type" {
  description = "Determines whether a Standard or Express state machine is created."
  type        = string
  default     = "STANDARD"
}

variable "publish_status" {
  description = "Set to true to publish a version of the state machine during creation."
  type        = bool
  default     = false
}

variable "logging_config_level" {
  description = "Set to true to publish a version of the state machine during creation."
  type        = string
  default     = "ERROR"
}

variable "include_execution_data_status" {
  description = "Determines whether execution data is included in your log."
  type        = bool
  default     = false
}

variable "start_task" {
  description = "Name of the starting task"
  type        = string
}

#variable "state_object_list" {
#  description = "A list of dynamic states with their names and resources."
#  type        = list(object({
#    Type          = string
#    Name          = string
#    Resource      = string
##    resource_type = string
#  }))
#}

variable "definition_comment" {
  type = string
  default = "definition comment"
}

variable "state_object_list" {
  default = [
    {
      name     = "task1",
      type     = "Task",
      resource = "arn:aws:lambda:us-east-1:064047601590:function:iot-test",
#      end      = false
    },
    {
      name     = "task2",
      type     = "Task",
      resource = "arn:aws:lambda:us-east-1:064047601590:function:iot-test2",
#      end      = true
    }
  ]
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
#
variable "policy_count" {
  description = "Number of policies to attach to the IAM role"
  type        = number
  default     = 0
}
#
variable "sfn_role_name" {
  description = "Name of the Lambda Role name."
  type        = string
  default     = null
}
#
variable "assume_role_policy" {
  description = "The policy to be assumed by lambda"
  type        = string
  default     = null
}
#
variable "iam_policy_name"{
  description = "Name of the policy to be attached to the Lambda role"
  type        = string
  default     = null
}
#
variable "permission_boundary"{
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = "arn:aws:iam::064047601590:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_DishTaasAdminDev_ea612f790bd52334"
}

variable "flag_use_existing_policy" {
  description = "Specify 'true' if you want to use an existing IAM policy, or 'false' to create a new policy."
  type        = bool
  default     = true
}
#
variable "existing_iam_policy_arns" {
  description = "The ARN of an existing IAM policy to be attached to the Lambda execution role."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
}
#
#variable "handler" {
#  description = "Lambda function handler."
#  type        = string
#  default     = "index.handler"
#}
#
#variable "runtime" {
#  description = "Lambda function runtime."
#  type        = string
#  default     = "python3.8"
#}
#
variable "new_iam_policy" {
  type = string
  default = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
              "lambda:Get*",
              "lambda:List*",
              "cloudwatch:GetMetricData",
              "cloudwatch:ListMetrics"
          ],
          "Effect": "Allow",
          "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogStreams",
                "logs:GetLogEvents",
                "logs:FilterLogEvents",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:DescribeQueries",
                "logs:GetLogGroupFields",
                "logs:GetLogRecord",
                "logs:GetQueryResults"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
        }
      ]
    }
  EOT
}
