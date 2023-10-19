output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.IOT_role.iam_role_arn
}