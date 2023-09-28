/*
Terraform root configuration - Includes modules related configuration
*/

#Modules
module "ec2-instance" {
  source                  = "/home/ec2-user/iot/aws/modules/ec2"
  instance_count          = 2
  ami_id                  = "ami-0a89b4f85b0b6f49c"
  instance_type           = "t2.micro"
  root_volume_type        = "gp3"
  root_volume_size        = 20
  root_volume_encrypted   = true
  root_volume_termination = true
  instance_names          = ["Dev1_Env", "Dev2_Env"]
  iam_role                = "ssm-role-5g-dp-dev"
  key_pair_name           = "Leto_DishTaasAdminDev_EC2"
  subnet_id               = "subnet-05b845545c737ac56"
  vpc_security_group_ids  = ["sg-09141b3415e566e1a"]
}
