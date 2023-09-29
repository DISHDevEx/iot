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
  region = var.aws_region
}
EOF
}

#Backend
remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    path = "${get_terragrunt_dir()}/local_backend/terraform.tfstate"
  }
}