terraform {
  # Deploy version v0.0.3 in stage
  source = "git@github.com:DISHDevEx/iot.git//aws/modules/glue"
}


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = var.aws_region
  profile = "iot_taas_sand_rish"
}
EOF
}

inputs = {
  aws_region = "us-east-1"
  job_names = ["Gluejob1_t","Gluejob2_t"]
  connections = []
  create_role = false
  role_arn = "arn:aws:iam::713778016910:role/AWSGlueJobRole"
  description = "IOT Glue job"
  glue_version = "3.0"
  max_retries = 0
  timeout = 60
  security_configuration = ""
  worker_type = "G.1X"
  number_of_workers = 2
  script_location = "s3://aws-glue-assets-713778016910-us-west-2/scripts/AWSGlueJobDemo.py"
  python_version = 3
  job_language = "python"
  class = null
  extra_py_files = []
  extra_jars = []
  user_jars_first = null
  use_postgres_driver = null
  extra_files = []
  job_bookmark_option = "job-bookmark-disable"
  temp_dir = null
  enable_s3_parquet_optimized_committer = true
  enable_rename_algorithm_v2 = true
  enable_glue_datacatalog = true
  enable_metrics = false
  enable_continuous_cloudwatch_log = false
  enable_continuous_log_filter = true
  continuous_log_stream_prefix = null
  continuous_log_conversion_pattern = null
  enable_spark_ui = false
  spark_event_logs_path = null
  additional_python_modules = []
  max_concurrent_runs = 1
}
