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
  region     = var.aws_region
  access_key = coalesce(var.aws_access_key, data.hcp_vault_secrets_app.application.secrets.aws_access_key)
  secret_key = coalesce(var.aws_secret_key, data.hcp_vault_secrets_app.application.secrets.aws_secret_key)
  token      = coalesce(var.aws_session_token, data.hcp_vault_secrets_app.application.secrets.aws_session_token)
}
provider "hcp" {
  #We are using Hashicorp Vault for managing secrets related to this module
  #Before using this module,please ensure that Hashicorp Vault CLI is installed and respective credentials are configured in the system environment variables
}