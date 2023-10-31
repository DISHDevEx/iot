#Outputs
#iam_role - module output
output "iam_role_outputs" {
  description = "iam role name and arn"
  value       = module.iam_role[*]
}

#ec2_instance - module output
output "ec2_instance_outputs" {
  description = "ID and Name of the EC2 instance"
  value       = module.ec2_instance[*]
}

#s3_bucket - module output
output "s3_bucket_outputs" {
  description = "S3 bucket name and other properties"
  value       = module.s3_bucket[*]
}

# glue_job - module output
output "glue_job_outputs" {
  description = "glue job names"
  value       = module.glue_job[*]
}

# lambda_function - module output
output "lambda_function_outputs" {
  description = "Lambda function name and arn"
  value       = module.lambda_function1[*]
}

output "lambda_function_outputs2" {
  description = "Lambda function name and arn"
  value       = module.lambda_function2[*]
}

output "lambda_function_outputs3" {
  description = "Lambda function name and arn"
  value       = module.lambda_function3[*]
}

# vpc - module output
# output "vpc_outputs" {
#   description = "VPC name"
#   value       = module.vpc[*]
# }

# security-group - module output
output "security-group_outputs" {
  description = "Lambda function name and arn"
  value       = module.security-group[*]
}

# sqs - module output
output "sqs_outputs" {
  description = "ID of the SQS queue"
  value       = module.sqs[*]
}

# sagemaker - module output
output "sagemaker_outputs" {
  description = "Sagemaker instance name"
  value       = module.sagemaker[*]
}