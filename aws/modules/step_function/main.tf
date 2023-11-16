#Assigning the local region variable
data "aws_region" "current" {
}


#Assigning the local account id
data "aws_caller_identity" "current" {
}

locals {
  count = length(var.state_object_list) - 1
  next_states = {
  for index, state in slice(var.state_object_list, 0, local.count)  : state.name => {
    Type = state.type
    Resource = state.resource
    Next =  var.state_object_list[index+1].name
  }
  }
  end_state = {
  for index, state in slice(var.state_object_list, local.count , local.count + 1)  : state.name => {
    Type     = state.type
    Resource = state.resource
    End      = true
  }
  }

}


module "sfn_iam" {
  count                    = var.flag_use_existing_role ? 0 : 1
  source                   = "git@github.com:DISHDevEx/iot.git//aws/modules/iam"
  aws_region               = data.aws_region.current.name
  iam_role_name            = var.sfn_role_name
  assume_role_policy       = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  iam_policy_name          = var.flag_use_existing_policy ? null : var.iam_policy_name
  iam_policy               = var.flag_use_existing_policy ? null : var.new_iam_policy
  flag_use_existing_policy = var.flag_use_existing_policy
  policy_count             = var.policy_count
  existing_iam_policy_arns = var.existing_iam_policy_arns
  permission_boundary      = var.permission_boundary
}

resource "aws_cloudwatch_log_group" "sfn" {
  name = "iot-${var.step_function_cloudwatch_log}"

  tags = {
    Environment = "test"
    Application = "iot"
  }
}

data "aws_cloudwatch_log_group" "sfn_data" {
  name          = aws_cloudwatch_log_group.sfn.name
}


resource "aws_sfn_state_machine" "step_function" {
  name     = "iot-${var.step_function_name}"
  role_arn = var.flag_use_existing_role ? var.existing_role_arn : module.sfn_iam[0].iam_role_arn
  type     = var.state_machine_type
  publish  = var.publish_status
  definition = jsonencode({
    Comment = var.definition_comment
    StartAt = var.start_task
    States = merge(local.next_states, local.end_state)
  })
  logging_configuration {
    log_destination        = "${data.aws_cloudwatch_log_group.sfn_data.arn}:*"
    include_execution_data = var.include_execution_data_status
    level                  = var.logging_config_level
  }
}

