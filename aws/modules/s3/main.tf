/*
#Resources
#S3 resouce configuration
*/
resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name
  region = var.aws_region
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.s3.id #Here the 'id' attribute will provide the S3 bucket name
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]

  bucket = aws_s3_bucket.s3.id
  acl    = "private"
}

/*
Note:
While the versioning_configuration.status parameter supports Disabled, this value is only intended for creating or importing resources that correspond to unversioned S3 buckets.
Updating the value from Enabled or Suspended to Disabled will result in errors as the AWS S3 API does not support returning buckets to an unversioned state.
*/
resource "aws_s3_bucket_versioning" "object_versioning" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = var.object_versioning #Supported parameters: "Enabled" or "Suspended" or "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "object_encryption" {
  bucket = aws_s3_bucket.s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" #Server-side encryption with Amazon S3 managed keys (SSE-S3)
    }
  }
}

/*
### Module Inputs - With HashiCorp Vault:
#Example for 's3' module
1. bucket_name       = data.vault_generic_secret.getsecrets.data["s3_bucket_name"]
2. aws_region        = data.vault_generic_secret.getsecrets.data["aws_region"]
3. object_versioning = data.vault_generic_secret.getsecrets.data["aws_s3_object_versioning"]

**Note:** Here the variable vaules of bucket, region and object_versioning will be passed directly from HashiCorp Vault.

### Module Inputs - Without HashiCorp Vault:
#Example for 's3' module
1. bucket_name       = "xxxxxx"
2. aws_region        = "xxxxxx"
3. object_versioning = "xxxxxx"
*/