#Outputs
#ec2_instance - module output
# output "ec2_instance_id_and_name" {
#   description = "ID and Name of the EC2 instance"
#   value       = module.ec2_instance[*]
# }
#s3_bucket - module output
output "s3_bucket" {
  description = "S3 bucket name and other properties"
  value       = module.s3_bucket[*]
}

# iamrole - module output
output "iam" {
  description = "iam role name and other properties"
  value       = module.iam[*]
}