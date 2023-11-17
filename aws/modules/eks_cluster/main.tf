#Assigning the local region variable
data "aws_region" "current" {
}

#Assigning the local account id
data "aws_caller_identity" "current" {
}

# VPC module
module "vpc" {
  count                                  = var.flag_use_existing_vpc ? 0 : 1
  source                                 = "git@github.com:DISHDevEx/iot.git//aws/modules/vpc"
  vpc_name                               = var.vpc_name
  vpc_cidr_block                         = var.vpc_cidr
  vpc_instance_tenancy                   = var.vpc_instance_tenancy
  vpc_enable_dns_support                 = var.dns_support
  vpc_enable_dns_hostnames               = var.dns_hostnames
  vpc_assign_generated_ipv6_cidr_block   = var.vpc_assign_generated_ipv6_cidr_block

  subnet_name                            = var.flag_use_existing_subnet ? null : var.subnet_name
  subnet_cidr_block                      = var.flag_use_existing_subnet ? null : var.subnet_cidr_blocks
  subnet_availability_zone               = var.flag_use_existing_subnet ? null : var.subnet_az
  subnet_map_public_ip_on_launch         = var.flag_use_existing_subnet ? null : var.map_public_ip_on_launch_public
  subnet_assign_ipv6_address_on_creation = var.flag_use_existing_subnet ? null : var.subnet_assign_ipv6_address_on_creation

  route_table_name                       = var.flag_use_existing_subnet_route_table ? null : var.route_table_name
  route_table_cidr_block                 = var.flag_use_existing_subnet_route_table ? null : var.route_table_subnet_cidr
  route_table_gateway_id                 = var.flag_use_existing_subnet_route_table ? null : var.route_table_gateway_id

}

module "eks_execution_role" {
  count                    = var.flag_use_existing_eks_execution_role ? 0 : 1
  source                   = "git@github.com:DISHDevEx/iot.git//aws/modules/iam"
  aws_region               = data.aws_region.current.name
  iam_role_name            = var.eks_role_name
  assume_role_policy       = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  iam_policy_name          = var.flag_use_existing_policy ? null : var.iam_policy_name
  iam_policy               = var.flag_use_existing_policy ? null : var.new_iam_policy
  flag_use_existing_policy = var.flag_use_existing_policy
  policy_count             = var.eks_execution_role_policy_count
  existing_iam_policy_arns = var.existing_eks_execution_role_iam_policy_arns
  permission_boundary      = var.eks_role_permission_boundary
}

##Creating EKS Cluster
resource "aws_eks_cluster" "eks_cluster_template" {
  name     = "${var.resource_prefix}${var.eks_cluster_name}"
  role_arn = var.flag_use_existing_eks_execution_role ? var.existing_eks_iam_role_arn : module.eks_execution_role[0].iam_role_arn

  vpc_config {
    subnet_ids = var.flag_use_existing_subnet ? var.existing_subnet_ids : module.vpc[0].subnet_ids
  }

}

module "node_group_role" {
  count                    = var.flag_use_existing_node_group_role ? 0 : 1
  source                   = "git@github.com:DISHDevEx/iot.git//aws/modules/iam"
  aws_region               = data.aws_region.current.name
  iam_role_name            = var.existing_node_group_iam_role_arn
  assume_role_policy       = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  iam_policy_name          = var.flag_use_existing_node_group_iam_policy ? null : var.iam_policy_name
  iam_policy               = var.flag_use_existing_node_group_iam_policy ? null : var.new_iam_policy
  flag_use_existing_policy = var.flag_use_existing_node_group_iam_policy
  policy_count             = var.node_group_policy_count
  existing_iam_policy_arns = var.existing_node_group_iam_policy_arns
  permission_boundary      = var.node_group_permission_boundary
}

###Creating Managed Node group
resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster_template.name
  node_group_name = "${var.resource_prefix}${var.eks_node_group_name}"
  node_role_arn   = var.flag_use_existing_node_group_role ? var.existing_node_group_iam_role_arn : module.node_group_role[0].iam_role_arn

  subnet_ids = var.flag_use_existing_subnet ? var.existing_subnet_ids : module.vpc[0].subnet_ids
  capacity_type  = var.eks_node_capacity_type
  instance_types = var.eks_node_instance_types

  scaling_config {
    desired_size = var.eks_node_desired_size
    max_size     = var.eks_node_max_size
    min_size     = var.eks_node_min_size
  }

  update_config {
    max_unavailable = var.eks_node_max_unavailable
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_eks_cluster.eks_cluster_template
  ]
}

###Create Helm Chart
module "helm-chart" {
  count                    = var.flag_create_hc ? 1 : 0
  source                   = "git@github.com:DISHDevEx/iot.git//aws/modules/helm"
#  count                      = var.app["deploy"] ? 1 : 0
  namespace                  = var.namespace
  repository                 = var.repository
  repository_key_file        = lookup(var.repository_config, "repository_key_file", null)
  repository_cert_file       = lookup(var.repository_config, "repository_cert_file", null)
  repository_ca_file         = lookup(var.repository_config, "repository_ca_file", null)
  repository_username        = lookup(var.repository_config, "repository_username", null)
  repository_password        = lookup(var.repository_config, "repository_password", null)
  name                       = var.app["name"]
  version                    = var.app["version"]
  chart                      = var.app["chart"]
  force_update               = lookup(var.app, "force_update", true)
  wait                       = lookup(var.app, "wait", true)
  recreate_pods              = lookup(var.app, "recreate_pods", true)
  max_history                = lookup(var.app, "max_history", 0)
  lint                       = lookup(var.app, "lint", true)
  cleanup_on_fail            = lookup(var.app, "cleanup_on_fail", false)
  create_namespace           = lookup(var.app, "create_namespace", false)
  disable_webhooks           = lookup(var.app, "disable_webhooks", false)
  verify                     = lookup(var.app, "verify", false)
  reuse_values               = lookup(var.app, "reuse_values", false)
  reset_values               = lookup(var.app, "reset_values", false)
  atomic                     = lookup(var.app, "atomic", false)
  skip_crds                  = lookup(var.app, "skip_crds", false)
  render_subchart_notes      = lookup(var.app, "render_subchart_notes", true)
  disable_openapi_validation = lookup(var.app, "disable_openapi_validation", false)
  wait_for_jobs              = lookup(var.app, "wait_for_jobs", false)
  dependency_update          = lookup(var.app, "dependency_update", false)
  replace                    = lookup(var.app, "replace", false)
  timeout                    = lookup(var.app, "timeout", 300)
  values                     = var.values

  depends_on = [aws_eks_cluster.eks_cluster_template]
}
