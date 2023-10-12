#Outputs
output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.s3.id
}
output "s3_bucket_region" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.s3.region
}
output "s3_object_versioning" {
  description = "S3 bucket - Object versioning"
  value       = aws_s3_bucket_versioning.object_versioning.versioning_configuration
}
output "s3_object_encryption" {
  description = "S3 bucket - Object encyption"
  value       = aws_s3_bucket_server_side_encryption_configuration.object_encryption
}