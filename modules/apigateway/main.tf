resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  description   = var.description
  protocol_type = var.protocol_type
  version       = var.api_version
  body          = var.body

  route_selection_expression   = var.route_selection_expression
  api_key_selection_expression = var.api_key_selection_expression
  disable_execute_api_endpoint = var.disable_execute_api_endpoint

  /* Start of quick create */
  route_key       = var.route_key
  credentials_arn = var.credentials_arn
  target          = var.target
  /* End of quick create */

  dynamic "cors_configuration" {
    for_each = length(keys(var.cors_configuration)) == 0 ? [] : [var.cors_configuration]

    content {
      allow_credentials = try(cors_configuration.value.allow_credentials, null)
      allow_headers     = try(cors_configuration.value.allow_headers, null)
      allow_methods     = try(cors_configuration.value.allow_methods, null)
      allow_origins     = try(cors_configuration.value.allow_origins, null)
      expose_headers    = try(cors_configuration.value.expose_headers, null)
      max_age           = try(cors_configuration.value.max_age, null)
    }
  }

  tags = var.tags
}

# Default stage
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true

  dynamic "access_log_settings" {
    for_each = var.default_stage_access_log_destination_arn != null && var.default_stage_access_log_format != null ? [true] : []

    content {
      destination_arn = var.default_stage_access_log_destination_arn
      format          = var.default_stage_access_log_format
    }
  }

  dynamic "default_route_settings" {
    for_each = length(keys(var.default_route_settings)) == 0 ? [] : [var.default_route_settings]

    content {
      data_trace_enabled = try(default_route_settings.value.data_trace_enabled, false) # supported in Websocket APIGateway only
      logging_level      = try(default_route_settings.value.logging_level, null)       # supported in Websocket APIGateway only

      detailed_metrics_enabled = try(default_route_settings.value.detailed_metrics_enabled, false)
      throttling_burst_limit   = try(default_route_settings.value.throttling_burst_limit, null)
      throttling_rate_limit    = try(default_route_settings.value.throttling_rate_limit, null)
    }
  }

  dynamic "route_settings" {
    for_each = { for k, v in var.integrations : k => v if length(setintersection(["data_trace_enabled", "detailed_metrics_enabled", "logging_level", "throttling_burst_limit", "throttling_rate_limit"], keys(v))) > 0 }

    content {
      route_key          = route_settings.key
      data_trace_enabled = try(route_settings.value.data_trace_enabled, var.default_route_settings["data_trace_enabled"], false) # supported in Websocket APIGateway only
      logging_level      = try(route_settings.value.logging_level, var.default_route_settings["logging_level"], null)            # supported in Websocket APIGateway only

      detailed_metrics_enabled = try(route_settings.value.detailed_metrics_enabled, var.default_route_settings["detailed_metrics_enabled"], false)
      throttling_burst_limit   = try(route_settings.value.throttling_burst_limit, var.default_route_settings["throttling_burst_limit"], null)
      throttling_rate_limit    = try(route_settings.value.throttling_rate_limit, var.default_route_settings["throttling_rate_limit"], null)
    }
  }

  tags = var.tags

  # Bug in terraform-aws-provider with perpetual diff
  lifecycle {
    ignore_changes = [deployment_id]
  }
}

# Routes and integrations
resource "aws_apigatewayv2_route" "this" {
  for_each = var.integrations

  api_id    = aws_apigatewayv2_api.this.id
  route_key = each.key

  api_key_required                    = try(each.value.api_key_required, null)
  authorization_scopes                = try(split(",", each.value.authorization_scopes), null)
  authorization_type                  = try(each.value.authorization_type, "NONE")
  authorizer_id                       = try(each.value.authorizer_id, null)
  model_selection_expression          = try(each.value.model_selection_expression, null)
  operation_name                      = try(each.value.operation_name, null)
  route_response_selection_expression = try(each.value.route_response_selection_expression, null)
  target                              = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.integrations

  api_id      = aws_apigatewayv2_api.this.id
  description = try(each.value.description, null)

  integration_type    = try(each.value.integration_type, try(each.value.lambda_arn, "") != "" ? "AWS_PROXY" : "MOCK")
  integration_subtype = try(each.value.integration_subtype, null)
  integration_method  = try(each.value.integration_method, try(each.value.integration_subtype, null) == null ? "POST" : null)
  integration_uri     = try(each.value.lambda_arn, try(each.value.integration_uri, null))

  connection_type = try(each.value.connection_type, "INTERNET")
  connection_id   = try(try(each.value.connection_id, null))

  payload_format_version    = try(each.value.payload_format_version, null)
  timeout_milliseconds      = try(each.value.timeout_milliseconds, null)
  passthrough_behavior      = try(each.value.passthrough_behavior, null)
  content_handling_strategy = try(each.value.content_handling_strategy, null)
  credentials_arn           = try(each.value.credentials_arn, null)
  request_parameters        = try(jsondecode(each.value["request_parameters"]), each.value["request_parameters"], null)

  dynamic "tls_config" {
    for_each = flatten([try(jsondecode(each.value["tls_config"]), each.value["tls_config"], [])])

    content {
      server_name_to_verify = tls_config.value["server_name_to_verify"]
    }
  }

  dynamic "response_parameters" {
    for_each = flatten([try(jsondecode(each.value["response_parameters"]), each.value["response_parameters"], [])])

    content {
      status_code = response_parameters.value["status_code"]
      mappings    = response_parameters.value["mappings"]
    }
  }
}
