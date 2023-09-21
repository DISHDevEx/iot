#Data sources
data "vault_generic_secret" "getsecrets" {
  path = var.vault_secrets_path
}
data "aws_subnet" "selected" {
  filter {
    name   = "subnet-id"
    values = [data.vault_generic_secret.getsecrets.data["aws_subnet_id"]]
  }
}
data "aws_security_group" "selected" {
  filter {
    name   = "group-id"
    values = [data.vault_generic_secret.getsecrets.data["aws_vpc_security_group_id"]]
  }
}
data "aws_iam_role" "role" {
  name = data.vault_generic_secret.getsecrets.data["aws_iam_role"]
}
data "aws_key_pair" "selected" {
  key_name = data.vault_generic_secret.getsecrets.data["ec2_key_pair_name"]
}
