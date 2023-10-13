/*
#Resources
#S3 resouce configuration
*/
resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name
}

/*
Note:
While the versioning_configuration.status parameter supports Disabled, this value is only intended for creating or importing resources that correspond to unversioned S3 buckets.
Updating the value from Enabled or Suspended to Disabled will result in errors as the AWS S3 API does not support returning buckets to an unversioned state.
*/
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = var.bucket_versioning #Supported parameters: "Enabled" or "Suspended" or "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "server_side_encryption" {
  bucket = aws_s3_bucket.s3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" #Server-side encryption with Amazon S3 managed keys (SSE-S3)
    }
  }
}
#Note: 'bucket_policy_file_path' is a 'Optional' input
resource "aws_s3_bucket_policy" "bucket_policy" {
  for_each = var.passing_bucket_policy_file_path ? { "enabled" = 1 } : { "disabled" = 0 }
  bucket = aws_s3_bucket.s3.id
  policy = file(var.bucket_policy_file_path)
}

/*
### Module Inputs - With HashiCorp Vault:
#Example for 's3' module
1. bucket_name = data.vault_generic_secret.getsecrets.data["bucket_name"]
2. bucket_versioning = data.vault_generic_secret.getsecrets.data["bucket_versioning"]
# The 'bucket_policy_file_path' is a 'Optional' input.
# So, use below variables only when you want to create the S3 bucket by passing input to 'bucket_policy_file_path'
3. passing_bucket_policy_file_path = true
4. bucket_policy_file_path = data.vault_generic_secret.getsecrets.data["bucket_policy_file_path"]

**Note:** Here the variable vaules of bucket_name, bucket_versioning and bucket_policy_file_path will be passed directly from HashiCorp Vault.

### Module Inputs - Without HashiCorp Vault:
#Example for 's3' module
1. bucket_name = "xxxxxx"
2. bucket_versioning = "xxxxxx"
# The 'bucket_policy_file_path' is a 'Optional' input.
# So, use below variables only when you want to create the S3 bucket by passing input to 'bucket_policy_file_path'
3. passing_bucket_policy_file_path = true
4. bucket_policy_file_path = "xxxxxx"
*/
