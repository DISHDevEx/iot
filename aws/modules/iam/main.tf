terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

#resources for IAM Role

resource "aws_iam_role" "IOT_role" {
  name = var.name

  assume_role_policy = var.assume_role_policy
}


resource "aws_iam_role_policy_attachment" "IOT_attachment" {
  role       = aws_iam_role.IOT_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


# Resources for Glue

# locals {
#   full_name = "${var.organization}${length(var.organization) > 0 ? "-" : ""}${var.environment}-${var.name}"
#   tags      = merge({
#     Terraform   = "True"
#     Environment = var.environment
#   }, var.tags)
# }

resource "aws_glue_job" "IOT_glue_job" {
  name = "IOTgluejob"
  role_arn = var.create_role ? join("", aws_iam_role.IOT_role.*.arn) : var.role_arn
  connections = var.connections
  description = var.description
  glue_version = var.glue_version
  max_retries = var.max_retries
  timeout = var.timeout
  security_configuration = var.create_security_configuration ? join("", aws_glue_security_configuration.sec_cfg.*.id) : var.security_configuration
  worker_type = var.worker_type
  number_of_workers = var.number_of_workers
  tags = local.tags

  command {
    name            = "glueetl"
    script_location = var.script_location
    python_version  = var.python_version
  }

  default_arguments = {
    "--job-language"                          = var.job_language
    "--class"                                 = var.class
    "--extra-py-files"                        = length(var.extra_py_files) > 0 ? join(",", var.extra_py_files) : null
    "--extra-jars"                            = length(var.extra_jars) > 0 ? join(",", var.extra_jars) : null
    "--user-jars-first"                       = var.user_jars_first
    "--use-postgres-driver"                   = var.use_postgres_driver
    "--extra-files"                           = length(var.extra_files) > 0 ? join(",", var.extra_files) : null
    "--job-bookmark-option"                   = var.job_bookmark_option
    "--TempDir"                               = var.temp_dir
    "--enable-s3-parquet-optimized-committer" = var.enable_s3_parquet_optimized_committer
    "--enable-rename-algorithm-v2"            = var.enable_rename_algorithm_v2
    "--enable-glue-datacatalog"               = var.enable_glue_datacatalog ? "" : null
    "--enable-metrics"                        = var.enable_metrics ? "" : null
    "--enable-continuous-cloudwatch-log"      = var.enable_continuous_cloudwatch_log
    "--enable-continuous-log-filter"          = var.enable_continuous_log_filter
    "--continuous-log-logGroup"               = join("", aws_cloudwatch_log_group.log_group.*.name)
    "--continuous-log-logStreamPrefix"        = var.continuous_log_stream_prefix
    "--continuous-log-conversionPattern"      = var.continuous_log_conversion_pattern
    "--enable-spark-ui"                       = var.enable_spark_ui
    "--spark-event-logs-path"                 = var.spark_event_logs_path
    "--additional-python-modules"             = length(var.additional_python_modules) > 0 ? join(",", var.additional_python_modules) : null
  }

  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
  }

  dynamic "notification_property" {
    for_each = var.notify_delay_after == null ? [] : [1]

    content {
      notify_delay_after = var.notify_delay_after
    }
  }
}

resource "aws_iam_role" "role" {
  count = var.create_role ? 1 : 0
  name  = "${local.full_name}-role"
  tags  = local.tags

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = [
          "sts:AssumeRole"
        ]
        Principal = {
          "Service" = "glue.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  ]
}

