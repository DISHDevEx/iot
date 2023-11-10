/*
Terragrunt configuration for all modules.
*/
#Locals
locals {
  backend_vars = jsondecode(read_tfvars_file("./terraform.tfvars"))
}

#Terraform source
terraform {
  source = "./main.tf"
}

#Providers
/*
For the following provider variables, values can be assigned through 'terraform.tfvars' file or they can be via Hashicorp Vault data source.
#Via 'terraform.tfvars' file: 
Example:
aws_region = "us-east-1"
profile    = "########"
#Assignment via Vault:
Example: profile = data.vault_generic_secret.getsecrets.data["profile"] #This works only if you had pre-configured this secret value in your vault instance.
#Passing AWS account credentails using profile 
The variable value of 'profile' is used to pass the respective aws credentials from the 'credentials' file located in this path - '~/.aws/credentials'.
Before running this script, please ensure to configure your aws account credentails in above mentioned file accordingly.
Note: Please don't commit any file with sensitive information to code repository or publicly accessible location.
*/
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = var.aws_region
  profile = var.profile
}
/*
provider "vault" {
  address         = var.vault_address
  skip_tls_verify = true
  token           = var.vault_token
} 
*/
EOF
}

#S3 backend
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    /*
    For the following provider variables, values can be assigned through 'terraform.tfvars' file.
    As per the instructions in the README.md file, please ensure to add the variable values in the 'terraform.tfvars' file.
    */
    profile        = local.backend_vars.profile
    region         = local.backend_vars.aws_region
    bucket         = local.backend_vars.backend_bucket_name
    key            = local.backend_vars.backend_bucket_key
    encrypt        = true
    dynamodb_table = local.backend_vars.backend_dynamodb_table_name
  }
}