#Data sources
#HashiCorp Vault data source
/*
data "vault_generic_secret" "getsecrets" {
  path = var.vault_secrets_path
}
*/
#AWS data source
data "aws_caller_identity" "current" {}