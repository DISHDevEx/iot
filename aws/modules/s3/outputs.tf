#Outputs
output "s3_bucket_name_and_properties" {
  description = "S3 bucket name and other properties"
  value       = aws_s3_bucket.s3[*]
}