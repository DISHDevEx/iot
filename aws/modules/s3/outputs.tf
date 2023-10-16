#Outputs
output "s3_bucket_name_and_properties" {
  description = "S3 bucket name and other properties"
  value = {
    bucket_name            = aws_s3_bucket.s3.bucket
    bucket_region          = aws_s3_bucket.s3.region
    bucket_versioning      = aws_s3_bucket_versioning.bucket_versioning.versioning_configuration[0].status
    server_side_encryption = [for obj in aws_s3_bucket_server_side_encryption_configuration.server_side_encryption.rule : obj if obj.sse_algorithm != null]
    #server_side_encryption = aws_s3_bucket_server_side_encryption_configuration.server_side_encryption.rule
  }
}