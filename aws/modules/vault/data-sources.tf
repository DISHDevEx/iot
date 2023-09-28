#Data sources
data "vault_generic_secret" "getsecrets" {
  path = var.vault_secrets_path
}