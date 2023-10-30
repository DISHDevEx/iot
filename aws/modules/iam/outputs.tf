output "iam_role_arn" {
  description = "The ARN of the created Lambda function."
  value       = aws_iam_role.IOT_role.arn
}