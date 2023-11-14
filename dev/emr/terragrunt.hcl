# include "root" {
#   path = find_in_parent_folders()
# }

# locals {
#   config_vars = read_terragrunt_config(find_in_parent_folders("config.hcl")).locals
# }

# terraform {
#   source = "../../modules/emr"
# }

# inputs = {
#   name = local.config_vars.emr_name
#   release_label = local.config_vars.release_label
#   applications = local.config_vars.applications
#   idle_timeout = local.config_vars.idle_timeout
#   log_uri = local.config_vars.log_uri
#   service_iam_role_arn = local.config_vars.service_iam_role_arn
#   master_instance_group = local.config_vars.master_instance_group
#   core_instance_group = local.config_vars.core_instance_group
#   ec2_attributes = local.config_vars.ec2_attributes
#   configurations_json = local.config_vars.configurations_json
# }
