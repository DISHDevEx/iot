terraform {
  extra_arguments "common_vars" {
    commands = ["fmt", "plan", "apply"]

    arguments = [
      "-var-file=variables.tfvars"
    ]
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "us-east-1"
}
EOF
}

locals {
  config_vars = read_terragrunt_config("config.hcl").locals
}

# remote_state {
#   backend = "s3"
#   generate = {
#     path = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
#   config = {
#     bucket = local.config_vars.tfstate_bucket_name
#     key = local.config_vars.key # "${path_relative_to_include()}/terraform.tfstate"
#     region = "us-east-1"
#     encrypt = true
#     dynamodb_table = "${local.config_vars.dynamodb_table}"
#   }
# }
