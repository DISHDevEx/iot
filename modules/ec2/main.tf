/*
EC2 Module - This module can be used to create multiple EC2 instances of same - instance_type & ami_id in AWS cloud.
We are using HashiCorp Vault(Cloud Platform) for secrets management.
Along with other variable vaules,
please ensure that HashiCorp Vault(Cloud Platform) credentials(hcp_client_id,hcp_client_secret) & hcp_vault_app_name are configured in the respective '.tfvars' file.
Please AVOID committing any file with sensitive data to the code repository
*/
#Resources
resource "aws_instance" "ec2" {
  #The coalesce function will check if the first parameter is null or not, and if the first parameter is null then it will assign the second parameter value
  count                = var.instance_count
  ami                  = var.ami_id
  instance_type        = var.instance_type
  # iam_instance_profile = coalesce(var.aws_iam_role, local.data_source_iam_role)
  # key_name             = coalesce(var.key_pair_name, local.data_source_key_pair_name)
  subnet_id            = var.subnet_id
  #We can assign multiple security groups and this can be configured in 'data-sources.tf' file
  vpc_security_group_ids = var.vpc_security_group_ids
  #The count.index helps to assign respective instance names as per the respective variable value in the .tfvars file
  tags = {
    Name = var.instance_names[count.index]
  }
}
#Locals - To retreive the variable vaules from data sources
# locals {
#   data_source_subnet_id         = data.aws_subnet.selected.id
#   data_source_security_group_id = data.aws_security_group.selected.id
#   data_source_iam_role          = data.aws_iam_role.role.name
#   data_source_key_pair_name     = data.aws_key_pair.selected.key_name
# }
