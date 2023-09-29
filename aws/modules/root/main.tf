/*
Terraform root configuration - Includes modules related configuration
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
#Modules
module "ec2-instance" {
  source                  = "/home/ec2-user/iot/aws/modules/ec2"
  for_each = { for index, config in local.resource_configurations : index => config }
  instance_count          = each.value.instance_count
  ami_id                  = each.value.ami_id
  instance_type           = each.value.instance_type
  root_volume_type        = "gp3"
  root_volume_size        = 20
  root_volume_encrypted   = true
  root_volume_termination = true
  instance_names          = each.value.instance_names
  iam_role                = "ssm-role-5g-dp-dev"
  key_pair_name           = "Leto_DishTaasAdminDev_EC2"
  subnet_id               = "subnet-05b845545c737ac56"
  vpc_security_group_ids  = ["sg-09141b3415e566e1a"]
}
