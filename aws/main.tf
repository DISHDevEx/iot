/*
Terraform configuration for root module - Includes configuration related to other modules as well.
*/
#Locals - To create a resource with different configurations
locals {
  resource_configurations = [
    {
      instance_count = 2
      ami_id         = "ami-0a89b4f85b0b6f49c"
      instance_type  = "t2.micro"
      instance_names = ["Linux_Env1", "Linux_Env2"]
    },
    {
      instance_count = 2
      ami_id         = "ami-024c3652b28842b66"
      instance_type  = "t3.micro"
      instance_names = ["Ubuntu_Env1", "Ubuntu_Env2"]
    }
  ]
}
#EC2 module with HashiCorp Vault
module "ec2_instance" {
  source                  = "git@github.com:DISHDevEx/iot.git//aws/modules/ec2?ref=sriharsha/ec2-with-vault"
  for_each                = { for index, config in local.resource_configurations : index => config }
  instance_count          = each.value.instance_count
  ami_id                  = each.value.ami_id
  instance_type           = each.value.instance_type
  root_volume_type        = "gp3"
  root_volume_size        = 20
  root_volume_encrypted   = true
  root_volume_termination = true
  instance_names          = each.value.instance_names
  /*
  For the following variables, values can be assigned directly or they can be via Hashicorp data source.
  #Direct assignment:
  Example: iam_role = "xxxxxxxxxxx" #Provide respective IAM role name.
  #Assignment via Vault:
  Example: iam_role = data.vault_generic_secret.getsecrets.data["iam_role"] #This works only if you had pre-configured this value in your vault instance.
  Note: Please don't commit any file with sensitive information to code repository or publicly accessible location.
  */
  iam_role                = data.vault_generic_secret.getsecrets.data["iam_role"]
  key_pair_name           = data.vault_generic_secret.getsecrets.data["key_pair_name"]
  subnet_id               = data.vault_generic_secret.getsecrets.data["subnet_id"]
  vpc_security_group_ids  = [data.vault_generic_secret.getsecrets.data["vpc_security_group_ids"]]
}