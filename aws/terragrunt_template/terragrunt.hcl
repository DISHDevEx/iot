/*
Terragrunt configuration for all modules.
*/
#Locals
locals {
  varfile                     = get_env("TG_VAR_BACKEND_TFVARS_FILE")
  vardata                     = jsondecode(file(local.varfile))
  profile                     = local.vardata.profile
  aws_region                  = local.vardata.aws_region
  backend_bucket_name         = local.vardata.backend_bucket_name
  backend_bucket_key          = local.vardata.backend_bucket_key
  backend_dynamodb_table_name = local.vardata.backend_dynamodb_table_name
}

#Terraform source
terraform {
  source = "./main.tf"
  extra_arguments "s3_backend_vars" {
    commands  = get_terraform_commands_that_need_vars()
    arguments = local.varfile != null ? ["-var-file=${local.varfile}"] : []
  }
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
    For the following provider variables, values can be assigned through 's3_backend.tfvars.json' file only.
    As per the instructions in the README.md file, please ensure to create the 's3_backend.tfvars.json' file and set this file name as environment variable.
    */
    profile        = local.profile
    region         = local.aws_region
    bucket         = local.backend_bucket_name
    key            = local.backend_bucket_key
    encrypt        = true
    dynamodb_table = local.backend_dynamodb_table_name
  }
}

provider "helm" {
  kubernetes {
    host                   = "https://3284ED425F1E7875AF8A13A131A2DB9B.gr7.us-east-1.eks.amazonaws.com"
    
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJRjN6TmMxdDRuczR3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpFd01qWXlNRFU1TWpSYUZ3MHpNekV3TWpNeU1UQTBNalJhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUNiV3piTUdrSjJ0UEdVZmk3ZnZFVnUvaEV1TjB1ZzVSSGthVTlFVVlTdGlwU1drK0tNblJkcGwzeFIKdWt6ZkN1bGo1ek0wc3prRk11ZmFoYUdObENXYi9ybTFLNVlxVldiaDVRT2cwbW5lQjdEK2wrS0hqQWswTDlWbQpycldZL1N5R1RXZEkzRE5RSFFRNWVhMEUyMitVZklsTFc5MzkrY01EVjJlMVAyZE95TDV1bjRBMFNNd2o4c0NECnkrcEdmMkdOallNNlV4S2grZmlBU082ZTU2MFBlRm1PU3hnMGV3b3VPYXFkbGVWZDF1UVFCUGNlckFGZXNEZUgKbHpDZjBEeEQ0NE5NWmw0M1YzMDFVdDUxRkg0bFhPNTNmVzVobHFnZmJ6eTVUUDlrcjBlQVk5dVBNUTJacWFjVQpQNk85MDhIVGRkczhuaVZqejdvWEFPYWdCelRKQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJScDNsMzgzNUIzeFdvYTVqUkdCSmp0YWZUakVqQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQlVvYitHRnQ1VwptTFRzUG53bVJ0NE0zNTVIUHBCNDRpbkV0ellUOXhnd09Cc1JxWGYwNy83aHd2cFpsTWFtWHZFNHlRcFVtRlhGClFmdHR6bGlTUThidXRwMzVnR0xBT29rMUF2KzdpRUE2SHlmWFNmRFZVSDVBRE1rY2Npbm0xUFZQYjBBMUpDL1gKMlRheVBQVUFhcjlhRE1Rc0pEZWg0SjY4UVcyd0xDUmhLanQyWm05cGVGcWtPYzhCM0wwa2crYnN0SEpDYzhqYQpTMEExcDJ1ajY4anBnZkU2WmR6VE54WjNuelJLOG5YT1BoZC90RkVqT1FlUktNWVgva3R3RUVPRHJjY1kzUEk0Ck1UdVU1enk5d0E2NTNqNDY4WDh2SkJSTmVvbk9sbFJOM3hBTjVISm96TlZ3WW5MUmJ0R3ZIcFNNV0I2cC9HUHcKRTB0WnFJK3U0V1lnCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K")
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "Findr_test"]
      command     = "aws"
    }
  }
}