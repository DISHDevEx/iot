/*
Terragrunt configuration for all modules.
*/
#Terraform source
terraform {
  source = "./main.tf"
}

#Providers
/*
For the following provider variables, values can be assigned through 'terraform.tfvars' file or they can be via Hashicorp Vault data source.
#Via 'terraform.tfvars' file:
Example: access_key="xxxxxxxxx" in 'terraform.tfvars' file which should be available in same directory.
#Assignment via Vault:
Example: access_key = data.vault_generic_secret.getsecrets.data["access_key"] #This works only if you had pre-configured this value in your vault instance.
#Passing AWS account credentails using profile 
The profile is used to pass the aws credentials from the 'credentials' file located in this path - '~/.aws/credentials'.
Before running this script, please ensure to configure your aws account credentails in above mentioned file accordingly.
Note: Please don't commit any file with sensitive information to code repository or publicly accessible location.
*/
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
/*    
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.20.1"
    }
*/    
  }
}
provider "aws" {
  region     = var.aws_region
  profile    = var.profile
}
/*
provider "vault" {
  address         = var.vault_address
  skip_tls_verify = true
  token           = var.vault_token
*/
EOF
}

#S3 backend
remote_state {
  backend  = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    /*
    As we can't assign the variable values directly in this 'config' block, the 'get_env()' function is used to assign the values.
    Before using the 'get_env()' function, we should ensure to set the environment variables in the CLI as shown below
    Example:
    export TF_VAR_profile=xxxxxxxxxx
    export TF_VAR_bucket_name=xxxxxxxxxx
    export TF_VAR_bucket_key=xxxxxxxxxxx
    export TF_VAR_dynamodb_table_name=xxxxxxxxx
    */
    bucket         = get_env("TF_VAR_bucket_name")
    key            = get_env("TF_VAR_bucket_key")
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = get_env("TF_VAR_dynamodb_table_name")
    profile        = get_env("TF_VAR_profile")
  }
}