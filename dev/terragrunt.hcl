terraform {
  extra_arguments "common_vars" {
    commands = ["fmt", "plan", "apply"]

    arguments = [
      "-var-file=variables-dev.tfvars"
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

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "tfstate-dish-mp-sbx"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tfstatelock-dish-mp-sbx"
  }
}
