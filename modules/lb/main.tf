resource "aws_lb" "this" {
  name        = var.name

  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = var.security_groups
  subnets            = var.subnets

  idle_timeout                                = var.idle_timeout
  enable_cross_zone_load_balancing            = var.enable_cross_zone_load_balancing
  enable_xff_client_port                      = var.enable_xff_client_port
  ip_address_type                             = var.ip_address_type
  drop_invalid_header_fields                  = var.drop_invalid_header_fields
  preserve_host_header                        = var.preserve_host_header
  desync_mitigation_mode                      = var.desync_mitigation_mode
  xff_header_processing_mode                  = var.xff_header_processing_mode

  access_logs {
    bucket  = var.access_logs_bucket
    prefix  = var.access_logs_prefix
    enabled = var.access_logs_enabled
  }

  tags = var.tags
}

resource "aws_lb_target_group" "main" {
  count = length(var.target_groups)
  name        = lookup(var.target_groups[count.index], "name", null)

  vpc_id           = var.vpc_id
  port             = try(var.target_groups[count.index].backend_port, null)
  protocol         = try(upper(var.target_groups[count.index].backend_protocol), null)
  protocol_version = try(upper(var.target_groups[count.index].protocol_version), null)
  target_type      = try(var.target_groups[count.index].target_type, null)

  connection_termination             = try(var.target_groups[count.index].connection_termination, null)
  deregistration_delay               = try(var.target_groups[count.index].deregistration_delay, null)
  slow_start                         = try(var.target_groups[count.index].slow_start, null)
  proxy_protocol_v2                  = try(var.target_groups[count.index].proxy_protocol_v2, false)
  lambda_multi_value_headers_enabled = try(var.target_groups[count.index].lambda_multi_value_headers_enabled, false)
  load_balancing_algorithm_type      = try(var.target_groups[count.index].load_balancing_algorithm_type, null)
  preserve_client_ip                 = try(var.target_groups[count.index].preserve_client_ip, null)
  ip_address_type                    = try(var.target_groups[count.index].ip_address_type, null)
  load_balancing_cross_zone_enabled  = try(var.target_groups[count.index].load_balancing_cross_zone_enabled, null)

  dynamic "health_check" {
    for_each = try([var.target_groups[count.index].health_check], [])

    content {
      enabled             = try(health_check.value.enabled, null)
      interval            = try(health_check.value.interval, null)
      path                = try(health_check.value.path, null)
      port                = try(health_check.value.port, null)
      healthy_threshold   = try(health_check.value.healthy_threshold, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, null)
      timeout             = try(health_check.value.timeout, null)
      protocol            = try(health_check.value.protocol, null)
      matcher             = try(health_check.value.matcher, null)
    }
  }

  dynamic "stickiness" {
    for_each = try([var.target_groups[count.index].stickiness], [])

    content {
      enabled         = try(stickiness.value.enabled, null)
      cookie_duration = try(stickiness.value.cookie_duration, null)
      type            = try(stickiness.value.type, null)
      cookie_name     = try(stickiness.value.cookie_name, null)
    }
  }

  tags = merge(
    var.tags,
    lookup(var.target_groups[count.index], "tags", {}),
  )
}

locals {
  # Merge the target group index into a product map of the targets so we
  # can figure out what target group we should attach each target to.
  # Target indexes can be dynamically defined, but need to match
  # the function argument reference. This means any additional arguments
  # can be added later and only need to be updated in the attachment resource below.
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment#argument-reference
  target_group_attachments = merge(flatten([
    for index, group in var.target_groups : [
      for k, targets in group : {
        for target_key, target in targets : join(".", [index, target_key]) => merge({ tg_index = index }, target)
      }
      if k == "targets"
    ]
  ])...)

  # Filter out the attachments for lambda functions. The ALB target group needs permission to forward a request on to
  # the specified lambda function. This filtered list is used to create those permission resources.
  # To get the lambda_function_name, the 6th index is taken from the lambda_function_arn format below
  # arn:aws:lambda:<region>:<account-id>:function:my-function-name:<version-number>
  # target_group_attachments_lambda = {
  #   for k, v in local.target_group_attachments :
  #   (k) => merge(v, { lambda_function_name = split(":", v.target_id)[6] })
  #   if try(v.attach_lambda_permission, false)
  # }
}

# resource "aws_lambda_permission" "lb" {
#   for_each = { for k, v in local.target_group_attachments_lambda : k => v }

#   function_name = each.value.lambda_function_name
#   qualifier     = try(each.value.lambda_qualifier, null)

#   statement_id       = try(each.value.lambda_statement_id, "AllowExecutionFromLb")
#   action             = try(each.value.lambda_action, "lambda:InvokeFunction")
#   principal          = try(each.value.lambda_principal, "elasticloadbalancing.amazonaws.com")
#   source_arn         = aws_lb_target_group.main[each.value.tg_index].arn
#   source_account     = try(each.value.lambda_source_account, null)
#   event_source_token = try(each.value.lambda_event_source_token, null)
# }

resource "aws_lb_target_group_attachment" "this" {
  for_each = { for k, v in local.target_group_attachments : k => v }

  target_group_arn  = aws_lb_target_group.main[each.value.tg_index].arn
  target_id         = each.value.target_id
  port              = lookup(each.value, "port", null)
  availability_zone = lookup(each.value, "availability_zone", null)

  # depends_on = [aws_lambda_permission.lb]
}
