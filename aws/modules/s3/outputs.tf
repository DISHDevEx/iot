#Outputs
output "s3_bucket_name_and_properties" {
  description = "S3 bucket name and other properties"
  value = {
    bucket_name            = aws_s3_bucket.s3.bucket
    bucket_region          = aws_s3_bucket.s3.region
    bucket_versioning      = data.aws_s3_bucket.s3_data.versioning[0].status
    server_side_encryption = data.aws_s3_bucket.s3_data.server_side_encryption_configuration[0].rule[0].apply_server_side_encryption_by_default[0].sse_algorithm
  }
}