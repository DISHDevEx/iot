/*
#Resources
#S3 resouce configuration
*/
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
  count      = var.pass_bucket_policy_file
  depends_on = [aws_s3_bucket.s3]
  bucket     = aws_s3_bucket.s3.id
  policy     = file(var.bucket_policy_file_path)
}

/*
### Module Inputs - With HashiCorp Vault:
#Example for 's3' module
1. bucket_name = data.vault_generic_secret.getsecrets.data["bucket_name"]
2. bucket_versioning = data.vault_generic_secret.getsecrets.data["bucket_versioning"]
# If you want to pass any custom bucket policy - json file, then include below variables as well.
3. pass_bucket_policy_file = data.vault_generic_secret.getsecrets.data["pass_bucket_policy_file"]
4. bucket_policy_file_path = data.vault_generic_secret.getsecrets.data["bucket_policy_file_path"]
# If you want to create more than one S3 bucket with policy file, then ensure to pass respective bucket-policy files using 'bucket_policy_file_path' variable.

**Note:** Here the variable vaules of bucket_name, bucket_versioning, pass_bucket_policy_file, bucket_policy_file_path  will be passed directly from HashiCorp Vault.

### Module Inputs - Without HashiCorp Vault:
#Example for 's3' module
1. bucket_name = "xxxxxxxxx"
2. bucket_versioning = "xxxxxxx"
# If you want to pass any custom bucket policy - json file, then include below variables as well.
3. pass_bucket_policy_file = 1
4. bucket_policy_file_path = "xxxxxxx"
# If you want to create more than one S3 bucket with policy file, then ensure to pass respective bucket-policy files using 'bucket_policy_file_path' variable.
*/
