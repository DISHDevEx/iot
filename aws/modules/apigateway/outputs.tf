output "apigatewayv2_api_id" {
  description = "The API identifier"
  value       = try(aws_apigatewayv2_api.this.id, "")
}

output "apigatewayv2_api_api_endpoint" {
  description = "The URI of the API"
  value       = try(aws_apigatewayv2_api.this.api_endpoint, "")
}

output "apigatewayv2_api_arn" {
  description = "The ARN of the API"
  value       = try(aws_apigatewayv2_api.this.arn, "")
}

output "apigatewayv2_api_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = try(aws_apigatewayv2_api.this.execution_arn, "")
}

# default stage
output "default_apigatewayv2_stage_id" {
  description = "The default stage identifier"
  value       = try(aws_apigatewayv2_stage.default.id, "")
}

output "default_apigatewayv2_stage_arn" {
  description = "The default stage ARN"
  value       = try(aws_apigatewayv2_stage.default.arn, "")
}

output "default_apigatewayv2_stage_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = try(aws_apigatewayv2_stage.default.execution_arn, "")
}

output "default_apigatewayv2_stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = try(aws_apigatewayv2_stage.default.invoke_url, "")
}

output "default_apigatewayv2_stage_domain_name" {
  description = "Domain name of the stage (useful for CloudFront distribution)"
  value       = replace(try(aws_apigatewayv2_stage.default.invoke_url, ""), "/^https?://([^/]*).*/", "$1")
}
