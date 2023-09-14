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
  access_key = data.hcp_vault_secrets_app.application.secrets.aws_access_key
  secret_key = data.hcp_vault_secrets_app.application.secrets.aws_secret_key
  token = data.hcp_vault_secrets_app.application.secrets.aws_session_token
}
provider "hcp" {
  #Ensure that Hashicorp Vault credentials are configured in the system environment variables
}
#Data source
data "hcp_vault_secrets_app" "application" {
  app_name = var.hashicorp_vault_app_name
}