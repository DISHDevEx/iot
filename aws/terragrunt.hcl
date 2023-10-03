/*
Terragrunt configuration for root module
*/
#Terraform source
terraform {
  source = "./main.tf"
}

#Providers
/*
For the following provider variables, values can be assigned through 'terraform.tfvars' file or they can be via Hashicorp Vault data source.
#Via 'terraform.tfvars' file:
Example: access_key = "xxxxxxxxx" #Provide respective account access key in 'terraform.tfvars' file which should be available in same directory.
#Assignment via Vault:
Example: access_key = data.vault_generic_secret.getsecrets.data["access_key"] #This works only if you had pre-configured this value in your vault instance
Note: Please don't commit any file with sensitive information to code repository or publicly accessible location.
*/
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region     = var.aws_region
  #The profile "account1" is used to pass the aws credentials from the 'credentials' file located in this path - '~/.aws/credentials'
  #Before running this script, please ensure to configure your aws account credentails in above mentioned file accordingly.
  profile    = "account1"
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

#Backend
#S3 backend
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    /*
    As we can't assign the variable values directly in this 'config' block, the 'get_env()' function is used to assign the values.
    Before using the 'get_env()' function, we should ensure to set the environment variables in the CLI as shown below
    Example:
    export TF_VAR_region=xxxxxx
    export TF_VAR_bucket=xxxxxx
    export TF_VAR_dynamodb_table=xxxxxx
    */
    bucket         = get_env("TF_VAR_bucket")
    key            = "${path_relative_to_include()}/ec2/terraform.tfstate"
    region         = get_env("TF_VAR_region")
    encrypt        = true
    dynamodb_table = get_env("TF_VAR_dynamodb_table")
  }
}
