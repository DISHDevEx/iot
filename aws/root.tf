/*
Terraform root configuration - Includes modules related configuration
*/

#Modules
module "ec2-instance" {
  source = "./modules/ec2"
  vars_file = "./terraform.tfvars"
}
