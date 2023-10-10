# include "root" {
#   path = find_in_parent_folders()
# }

# locals {
#   config_vars = read_terragrunt_config(find_in_parent_folders("config.hcl")).locals
# }

# terraform {
#   source = "tfr:///terraform-aws-modules/s3-bucket/aws?version=3.15.1"
# }

# inputs = {
#   bucket = local.config_vars.bucket_name

#   attach_public_policy    = true
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }
