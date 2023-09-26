#--------With HashiCorp Vault block - Start----------------------
#Please note to comment out this whole this block if you DONT want to use this module with HashiCorp Vault for secrets management
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
  vpc_security_group_ids = coalesce(var.vpc_security_group_ids, [local.data_source_security_group_id])
  #The count.index helps to assign respective instance names as per the respective variable value in the .tfvars file
  tags = {
    Name = var.instance_names[count.index]
  }
}
#Locals - To retreive the variable vaules from data sources
locals {
  data_source_iam_role          = data.aws_iam_role.role.name
  data_source_key_pair_name     = data.aws_key_pair.selected.key_name
  data_source_subnet_id         = data.aws_subnet.selected.id
  data_source_security_group_id = data.aws_security_group.selected.id
}
#--------With HashiCorp Vault block - End----------------------

##-----------------------------------------------------------------

#--------Without HashiCorp Vault block - Start----------------------
#Please note to comment out this whole block if you WANT to use this module with HashiCorp Vault for secrets management
#Resources
resource "aws_instance" "ec2" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  monitoring             = true
  iam_instance_profile   = var.iam_role
  key_name               = var.key_pair_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  #The count.index helps to assign respective instance names as per the respective variable value in the .tfvars file
  tags = {
    Name = var.instance_names[count.index]
  }
}
#--------Without HashiCorp Vault block - End----------------------