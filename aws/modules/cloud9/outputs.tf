output "id" {
  description = "The ID of the environment."
  value       = try(aws_cloud9_environment_ec2.this.id, "")
}

output "arn" {
  description = "The ARN of the environment."
  value       = try(aws_cloud9_environment_ec2.this.arn, "")
}

output "type" {
  description = "The type of the environment."
  value       = try(aws_cloud9_environment_ec2.this.type, "")
}

output "url" {
  description = "The URL of the environment."
  value = try("https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.this.id}", "")
}
