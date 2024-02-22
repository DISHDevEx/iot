/*
#Resources
#S3 resouce configuration
*/
locals {
  bucket_policy_count = var.pass_bucket_policy_file == true ? 1 : 0
}

resource "aws_s3_bucket" "s3" {
  #The bucket name will be appended with 'iot-', to identify the resouces created with this module
  #Example: if you pass the bucket name as 'tg-test-bucket' then it will be updated as 'iot-tg-test-bucket'
  bucket = format("iot-%s", var.bucket_name)
}

/*
Note:
While the versioning_configuration.status parameter supports Disabled, this value is only intended for creating or importing resources that correspond to unversioned S3 buckets.
Updating the value from Enabled or Suspended to Disabled will result in errors as the AWS S3 API does not support returning buckets to an unversioned state.
*/
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  depends_on = [aws_s3_bucket.s3]
  bucket     = aws_s3_bucket.s3.id
  versioning_configuration {
    status = var.bucket_versioning #Supported parameters: "Enabled" or "Suspended" or "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "server_side_encryption" {
  depends_on = [aws_s3_bucket.s3]
  bucket     = aws_s3_bucket.s3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" #Server-side encryption with Amazon S3 managed keys (SSE-S3)
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count      = local.bucket_policy_count
  depends_on = [aws_s3_bucket.s3]
  bucket     = aws_s3_bucket.s3.id
  policy     = file(var.bucket_policy_file_path)
}

resource "aws_s3_bucket_logging" "logging_bucket" {
  bucket        = aws_s3_bucket.s3.id
  target_bucket = var.log_bucket
  target_prefix = "log/"
}

