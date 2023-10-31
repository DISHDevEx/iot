
# Resources for Glue
resource "aws_glue_job" "IOT_glue_job" {
  count                  = length(var.job_names)
  name                   = format("iot_%s", var.job_names[count.index])
  role_arn               = var.role_arn
  connections            = var.connections
  description            = var.description
  glue_version           = var.glue_version
  max_retries            = var.max_retries
  timeout                = var.timeout
  security_configuration = var.security_configuration
  worker_type            = var.worker_type
  number_of_workers      = var.number_of_workers

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
    "--continuous-log-logStreamPrefix"        = var.continuous_log_stream_prefix
    "--continuous-log-conversionPattern"      = var.continuous_log_conversion_pattern
    "--enable-spark-ui"                       = var.enable_spark_ui
    "--spark-event-logs-path"                 = var.spark_event_logs_path
    "--additional-python-modules"             = length(var.additional_python_modules) > 0 ? join(",", var.additional_python_modules) : null
  }

  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
  }
}


