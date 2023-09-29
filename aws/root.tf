/*
Terraform root configuration - Includes modules related configuration
*/

#Modules
module "ec2-instance" {
  source = "/home/ec2-user/iot/aws/modules/ec2"
  vars_file = "/home/ec2-user/iot/aws/terraform.tfvars"
}
