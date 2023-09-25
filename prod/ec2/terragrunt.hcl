# include "root" {
#   path = find_in_parent_folders()
# }

locals {
  config_vars = read_terragrunt_config(find_in_parent_folders("config.hcl")).locals
}

terraform {
  source = "../../modules/ec2"
}

inputs = {
  instance_count = 1
  instance_names = local.config_vars.instance_names
  ami_id = local.config_vars.ami_id
  instance_type = local.config_vars.instance_type
  vpc_security_group_ids = local.config_vars.vpc_security_group_ids
  subnet_id = local.config_vars.subnet_id
}
