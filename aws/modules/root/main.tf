/*
Terraform configuration for root module - Includes modules related configuration
*/
#Locals - To create a resource with different configurations
locals {
  resource_configurations = [
    {
      instance_count = 1
      ami_id         = "ami-0a89b4f85b0b6f49c"
      instance_type  = "t2.micro"
      instance_names = ["Linux_Env"]
    },
    {
      instance_count = 1
      ami_id         = "ami-024c3652b28842b66"
      instance_type  = "t3.micro"
      instance_names = ["Ubuntu_Env"]
    }
  ]
}
#EC2 module with HashiCorp Vault
module "ec2_instance" {
  source                  = "git@github.com:DISHDevEx/iot.git//aws/modules/ec2?ref=sriharsha/ec2-with-vault"
  for_each = { for index, config in local.resource_configurations : index => config }
  instance_count          = each.value.instance_count
  ami_id                  = each.value.ami_id
  instance_type           = each.value.instance_type
  root_volume_type        = "gp3"
  root_volume_size        = 20
  root_volume_encrypted   = true
  root_volume_termination = true
  instance_names          = each.value.instance_names
  iam_role                = data.vault_generic_secret.getsecrets.data["iam_role"]
  key_pair_name           = data.vault_generic_secret.getsecrets.data["key_pair_name"]
  subnet_id               = data.vault_generic_secret.getsecrets.data["subnet_id"]
  vpc_security_group_ids  = [data.vault_generic_secret.getsecrets.data["vpc_security_group_ids"]]
}