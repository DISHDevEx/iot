output "iam_role_name" {
  description = "IAM role name"
  value       = aws_iam_role.IOT_role.name
}

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = aws_iam_role.IOT_role.arn
}
