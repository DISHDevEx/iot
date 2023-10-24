output "lambda_function_name" {
  description = "The name of the created Lambda function."
  value       = aws_lambda_function.iot_lambda_template.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the created Lambda function."
  value       = aws_lambda_function.iot_lambda_template.arn
}
