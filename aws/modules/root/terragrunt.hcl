/*
This file can be used to create EC2 instances in desired AWS account using the 'ec2' Terraform module.
*/
#Terraform source
terraform {
  source = "./main.tf"
}

#Providers
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = var.aws_region
}
provider "vault" {
  address         = var.vault_address
  skip_tls_verify = true
  token           = var.vault_token
}
EOF
}

#Backend
#Local backend
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
