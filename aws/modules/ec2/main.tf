#Resources
resource "aws_instance" "ec2" {
  #The coalesce function will check if the first parameter is null or not, and if the first parameter is null then it will assign the second parameter value
  count                = var.instance_count
  ami                  = var.ami_id
  instance_type        = var.instance_type
  monitoring           = true
  iam_instance_profile = coalesce(var.iam_role, local.data_source_iam_role)
  key_name             = coalesce(var.key_pair_name, local.data_source_key_pair_name)
  subnet_id            = coalesce(var.subnet_id, local.data_source_subnet_id)
  #We can assign multiple security groups and this can be configured in 'data-sources.tf' file
  vpc_security_group_ids = coalesce(var.vpc_security_group_ids, [local.data_source_security_group_ids])
  #Root Block Device configuration
  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    encrypted             = var.root_volume_encrypted
    delete_on_termination = var.root_volume_termination
  }
  #The count.index helps to assign respective instance names as per the respective variable value in the .tfvars file
  tags = {
    Name = var.instance_names[count.index]
  }
}
#Locals - To retreive the variable vaules from data sources
locals {
  data_source_iam_role           = data.vault_generic_secret.getsecrets.data["iam_role"]
  data_source_key_pair_name      = data.vault_generic_secret.getsecrets.data["key_pair_name"]
  data_source_subnet_id          = data.vault_generic_secret.getsecrets.data["subnet_id"]
  data_source_security_group_ids = data.vault_generic_secret.getsecrets.data["vpc_security_group_ids"]
}
