resource "aws_emr_cluster" "this" {
  applications    = var.applications

  auto_termination_policy {
    idle_timeout = var.idle_timeout
  }

  autoscaling_role = var.autoscaling_iam_role_arn

  dynamic "bootstrap_action" {
    for_each = var.bootstrap_action

    content {
      args = try(bootstrap_action.value.args, null)
      name = bootstrap_action.value.name
      path = bootstrap_action.value.path
    }
  }

  configurations      = var.configurations
  configurations_json = var.configurations_json

  dynamic "core_instance_group" {
    for_each = length(var.core_instance_group) > 0 ? [var.core_instance_group] : []

    content {
      autoscaling_policy = try(core_instance_group.value.autoscaling_policy, null)
      bid_price          = try(core_instance_group.value.bid_price, null)

      dynamic "ebs_config" {
        for_each = try(core_instance_group.value.ebs_config, [])

        content {
          iops                 = try(ebs_config.value.iops, null)
          size                 = try(ebs_config.value.size, 64)
          throughput           = try(ebs_config.value.throughput, null)
          type                 = try(ebs_config.value.type, "gp3")
          volumes_per_instance = try(ebs_config.value.volumes_per_instance, null)
        }
      }

      instance_count = try(core_instance_group.value.instance_count, null)
      instance_type  = core_instance_group.value.instance_type
      name           = try(core_instance_group.value.name, null)
    }
  }

  custom_ami_id        = var.custom_ami_id
  ebs_root_volume_size = var.ebs_root_volume_size

  dynamic "ec2_attributes" {
    for_each = length(var.ec2_attributes) > 0 ? [var.ec2_attributes] : []

    content {
      instance_profile                  = ec2_attributes.value.instance_profile
      key_name                          = try(ec2_attributes.value.key_name, null)
      subnet_id                         = try(ec2_attributes.value.subnet_id, null)
      subnet_ids                        = try(ec2_attributes.value.subnet_ids, null)
    }
  }

  keep_job_flow_alive_when_no_steps = true

  list_steps_states         = var.list_steps_states
  log_encryption_kms_key_id = var.log_encryption_kms_key_id
  log_uri                   = var.log_uri

  dynamic "master_instance_group" {
    for_each = length(var.master_instance_group) > 0 ? [var.master_instance_group] : []

    content {
      bid_price = try(master_instance_group.value.bid_price, null)

      dynamic "ebs_config" {
        for_each = try(master_instance_group.value.ebs_config, [])

        content {
          iops                 = try(ebs_config.value.iops, null)
          size                 = try(ebs_config.value.size, 64)
          throughput           = try(ebs_config.value.throughput, null)
          type                 = try(ebs_config.value.type, "gp3")
          volumes_per_instance = try(ebs_config.value.volumes_per_instance, null)
        }
      }

      instance_count = try(master_instance_group.value.instance_count, null)
      instance_type  = master_instance_group.value.instance_type
      name           = try(master_instance_group.value.name, null)
    }
  }

  name                   = var.name
  release_label          = var.release_label
  scale_down_behavior    = var.scale_down_behavior
  service_role           = var.service_iam_role_arn

  dynamic "step" {
    for_each = var.step

    content {
      action_on_failure = step.value.action_on_failure

      dynamic "hadoop_jar_step" {
        for_each = try([step.value.hadoop_jar_step], [])

        content {
          args       = try(hadoop_jar_step.value.args, null)
          jar        = hadoop_jar_step.value.jar
          main_class = try(hadoop_jar_step.value.main_class, null)
          properties = try(hadoop_jar_step.value.properties, null)
        }
      }

      name = step.value.name
    }
  }

  step_concurrency_level = var.step_concurrency_level
  termination_protection = var.termination_protection
  visible_to_all_users   = true

  tags = var.tags

  lifecycle {
    ignore_changes = [
      step,                # Ignore outside changes to running cluster steps
    ]
  }
}

resource "aws_emr_instance_group" "this" {
  for_each = { for k, v in [var.task_instance_group] : k => v if length(var.task_instance_group) > 0 }

  autoscaling_policy  = try(each.value.autoscaling_policy, null)
  bid_price           = try(each.value.bid_price, null)
  cluster_id          = aws_emr_cluster.this.id
  configurations_json = try(each.value.configurations_json, null)

  dynamic "ebs_config" {
    for_each = try(each.value.ebs_config, [])

    content {
      iops = try(ebs_config.value.iops, null)
      size = try(ebs_config.value.size, 64)
      type                 = try(ebs_config.value.type, "gp3")
      volumes_per_instance = try(ebs_config.value.volumes_per_instance, null)
    }
  }

  ebs_optimized  = try(each.value.ebs_optimized, true)
  instance_count = try(each.value.instance_count, null)
  instance_type  = each.value.instance_type
  name           = try(each.value.name, null)
}

resource "aws_emr_managed_scaling_policy" "this" {
  count = length(var.managed_scaling_policy) > 0 ? 1 : 0

  cluster_id = aws_emr_cluster.this.id

  compute_limits {
    unit_type                       = var.managed_scaling_policy.unit_type
    minimum_capacity_units          = var.managed_scaling_policy.minimum_capacity_units
    maximum_capacity_units          = var.managed_scaling_policy.maximum_capacity_units
    maximum_core_capacity_units     = try(var.managed_scaling_policy.maximum_core_capacity_units, null)
    maximum_ondemand_capacity_units = try(var.managed_scaling_policy.maximum_ondemand_capacity_units, null)
  }
}
