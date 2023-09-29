/*
This file can be used to create EC2 instances in desired AWS account using the 'ec2' Terraform module.
*/
#Terraform source
terraform {
  source = "./root.tf"
}

#Providers
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"
}
EOF
}

#Backend
remote_state {
  backend  = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    /*
    As we are assign the variable values directly in this 'config' block, the 'get_env()' function is used to assign the values.
    Before using the 'get_env()' function, we should ensure to set the environment variables in the CLI as shown below
    Example:
    export TF_VAR_region=xxxxxx
    export TF_VAR_bucket=xxxxxx
    export TF_VAR_dynamo_db_table=xxxxxx
    */
    bucket         = get_env("TF_VAR_bucket")
    key            = "${path_relative_to_include()}/ec2/terraform.tfstate"
    region         = get_env("TF_VAR_region")
    encrypt        = true
    dynamodb_table = get_env("TF_VAR_dynamodb_table")
  }
}