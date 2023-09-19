/*
Providers for ec2 Module - This module can be used to create multiple EC2 instances of same - instance_type & ami_id in AWS cloud.
We are using Hashicorp Vault(Cloud Platform) for managing secrets related to this module.
Along with other variable vaules,
please ensure that Hashicorp Vault(Cloud Platform) credentials(hcp_client_id,hcp_client_secret) & hcp_vault_app_name are configured in the respective '.tfvars' file.
Please AVOID committing any file with sensitive data to the code repository
*/
#Terraform required providers
terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.69.0"
    }
  }
}
#Providers
provider "aws" {
  region = var.aws_region
  #The coalesce function will check if the first parameter is null or not, and if the first parameter is null then it will assign the second parameter value
  access_key = coalesce(var.aws_access_key, data.hcp_vault_secrets_app.application.secrets.aws_access_key)
  secret_key = coalesce(var.aws_secret_key, data.hcp_vault_secrets_app.application.secrets.aws_secret_key)
  token      = coalesce(var.aws_session_token, data.hcp_vault_secrets_app.application.secrets.aws_session_token)
}
provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}