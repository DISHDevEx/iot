#Outputs
output "s3_bucket_name_and_properties" {
  description = "S3 bucket name and other properties"
  value = {
    bucket_name       = aws_s3_bucket.s3[*].bucket
    bucket_region     = aws_s3_bucket.s3[*].region
    object_versioning = aws_s3_bucket.s3[*].versioning
    encryption        = aws_s3_bucket.s3[*].server_side_encryption_configuration
  }
}