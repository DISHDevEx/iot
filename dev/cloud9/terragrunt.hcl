# include "root" {
#   path = find_in_parent_folders()
# }

locals {
  config_vars = read_terragrunt_config(find_in_parent_folders("config.hcl")).locals
}

terraform {
  source = "../../modules/cloud9"
}

inputs = {
  region = local.config_vars.region
  name = local.config_vars.cloud9_name
  subnet_id = local.config_vars.subnet_id
  tags = local.config_vars.tags
  create_membership = local.config_vars.create_membership
  user_arn = local.config_vars.user_arn
}
