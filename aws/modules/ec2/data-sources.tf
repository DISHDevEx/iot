#Data sources
data "aws_subnet" "selected" {
  filter {
    name   = "subnet-id"
    values = [data.hcp_vault_secrets_app.application.secrets.subnet_id]
  }
}
data "aws_security_group" "selected" {
  filter {
    name   = "group-id"
    values = [data.hcp_vault_secrets_app.application.secrets.vpc_security_group_id]
  }
}
data "aws_iam_role" "role" {
  name = data.hcp_vault_secrets_app.application.secrets.aws_iam_role
}
data "aws_key_pair" "selected" {
  key_name = data.hcp_vault_secrets_app.application.secrets.key_pair_name
}
data "hcp_vault_secrets_app" "application" {
  app_name = var.hashicorp_vault_app_name
}
