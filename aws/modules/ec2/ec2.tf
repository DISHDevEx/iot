/*
Prerequisite steps:
-------------------
Inorder to protect the sensitive data, we are using Hashicorp Vault (Cloud Version) to manage the secrets required.
Before running this terraform script, ensure to install the Hashicorp Vault CLI and configure the respective credentials as environment variables.
*/
#Resource
resource "aws_instance" "ec2" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  iam_instance_profile   = data.hcp_vault_secrets_app.application.secrets.iam_instance_profile
  key_name               = data.hcp_vault_secrets_app.application.secrets.key_name
  subnet_id              = data.hcp_vault_secrets_app.application.secrets.subnet_id
  vpc_security_group_ids = [data.hcp_vault_secrets_app.application.secrets.vpc_security_group_ids]
  tags = {
    Name  = var.instance_names[count.index]
  }
}
#Output
output "instance-id-and-public-ip" {
  value = zipmap(aws_instance.my-ec2[*].id, aws_instance.my-ec2[*].public_ip)
}