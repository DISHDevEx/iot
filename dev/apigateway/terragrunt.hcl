# include "root" {
#   path = find_in_parent_folders()
# }

# locals {
#   config_vars = read_terragrunt_config(find_in_parent_folders("config.hcl")).locals
# }

# terraform {
#   source = "../../modules/apigateway"
# }

# inputs = {
#   name = local.config_vars.apigw_name
#   protocol_type = local.config_vars.protocol_type
#   integrations = local.config_vars.integrations
#   default_route_settings = local.config_vars.default_route_settings
# }
