variable "eventbus_name" {
  description = "Name of the EventBridge event bus"
  type        = string
}

variable "role_permissions_boundary" {
  description = "role_permissions_boundary"
  type        = string
}

variable "eventbridge_configurations" {
  description = "List of EventBridge configurations"
  type        = list(object({
    role_name                = string
    rule_description         = string
    rule_schedule_expression = string
    target_name              = string
    target_arn               = string
  }))
}




