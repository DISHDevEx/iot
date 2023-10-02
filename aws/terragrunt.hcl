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
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
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
