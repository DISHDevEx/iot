#Data sources
#HashiCorp Vault data source
/*
data "vault_generic_secret" "getsecrets" {
  path = var.vault_secrets_path
}
*/


# Data source to get the IAM role ARN created by the "iam" module
# data "terraform_remote_state" "iam" {
#   backend = "s3"
#   config = {
#     bucket = "sriharsha-iot"
#     key    = "mss/rish/terraform.tfstate"
#     region = "us-east-1"
#   }
# }