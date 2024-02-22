module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws?ref=master"
  for_each = { for index, config in var.eventbridge_configurations : index => config }
  version = "v1.17.1"


  create_bus = false   # Use default bus
  role_permissions_boundary = var.role_permissions_boundary
  role_name = each.value.role_name

  rules = {
    "${each.value.rule_description}" = {
      description         = each.value.rule_description
      schedule_expression = each.value.rule_schedule_expression
    }
  }

  targets = {
    "${each.value.rule_description}" = [{
      name = each.value.target_name
      arn  = each.value.target_arn
    }]
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  for_each       = { for index, config in var.eventbridge_configurations : index => config }
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = each.value.target_arn
  principal      = "events.amazonaws.com"
  source_arn     = "${module.eventbridge[index(var.eventbridge_configurations, each.value)].eventbridge_rule_arns[each.value.rule_description]}"
}
