output "iam_arn" {
  description = "arn of the IAM role"
  value       = aws_iam_role.IOT_role.arn
}