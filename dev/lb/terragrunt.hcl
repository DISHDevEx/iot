# include "root" {
#   path = find_in_parent_folders()
# }

# locals {
#   config_vars = read_terragrunt_config(find_in_parent_folders("config.hcl")).locals
# }

# terraform {
#   source = "../../modules/lb"
# }

# inputs = {
#   name = local.config_vars.lb_name
#   load_balancer_type = local.config_vars.lb_type
#   internal = local.config_vars.internal
#   vpc_id = local.config_vars.vpc_id
#   security_groups = local.config_vars.vpc_security_group_ids
#   subnets = local.config_vars.subnets
#   target_groups = local.config_vars.target_groups
#   http_tcp_listeners = local.config_vars.http_tcp_listeners
#   http_tcp_listener_rules = local.config_vars.http_tcp_listener_rules
# }
