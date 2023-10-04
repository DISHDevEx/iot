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
Example: access_key = "xxxxxxxxx" #Provide respective account access key in 'terraform.tfvars' file which should be available in same directory.
#Assignment via Vault:
Example: access_key = data.vault_generic_secret.getsecrets.data["access_key"] #This works only if you had pre-configured this value in your vault instance.
#Passing AWS account credentails using profile 
The profile "DishTaasAdminDev" is used to pass the aws credentials from the 'credentials' file located in this path - '~/.aws/credentials'.
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
}
*/
EOF
}
