module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  for_each = { for index, config in local.eb_configurations : index => config}
  version = "v1.17.1"
  

  create_bus = false   # Use default bus
  role_permissions_boundary = var.role_permissions_boundary
  role_name = each.value.role_name

  rules = {
    "${each.value.rule_description}" = {
      description         = each.value.rule_description # "8 am MST"
      schedule_expression = each.value.rule_schedule_expression # "cron(0 15 ? * MON-FRI *)" # "cron(0 15 ? * 2 2022)" "cron(0 15 * * ? *)" # UTC 15pm (MST 8am) daily
    }
  }

  targets = {
    "${each.value.rule_description}" = [{
      name = each.value.target_name
      arn = each.value.target_arn
    }]
  }
}

locals {
  eb_configurations = [
    {
      role_name = "eventbridge_role_1"
      rule_description = "1"
      rule_schedule_expression = "cron(0 15 ? * MON-FRI *)"
      target_name = "1"
      target_arn = "arn:aws:lambda:us-east-1:064047601590:function:IOT_EBLambda"
    },
    {
      role_name = "eventbridge_role_2"
      rule_description = "2"
      rule_schedule_expression = "cron(0 15 ? * MON-FRI *)"
      target_name = "2"
      target_arn = "arn:aws:lambda:us-east-1:064047601590:function:IOT_EBLambda2"
    },
  ]
}





resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
    for_each = { for index, config in local.eb_configurations : index => config}
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = each.value.target_arn
    principal = "events.amazonaws.com"
    source_arn = "${module.eventbridge[index(local.eb_configurations, each.value)].eventbridge_rule_arns[each.value.rule_description]}"
}

