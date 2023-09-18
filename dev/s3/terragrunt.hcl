# include "root" {
#   path = find_in_parent_folders()
# }

terraform {
  source = "tfr:///terraform-aws-modules/s3-bucket/aws?version=3.15.1"
}

inputs = {
  bucket = "test-terragrunt-mp-us-east-1"

  attach_public_policy    = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
