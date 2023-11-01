/*
Terraform configuration for all modules.
*/
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#Modules without HashiCorp Vault
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#Locals
locals {
  #To create a EC2 resource with different configurations
  ec2_configurations = [
    {
      instance_count = 1
      ami_id         = "ami-0a89b4f85b0b6f49c"
      instance_type  = "t2.micro"
      instance_names = ["Linux_Env1"]
    },
    {
      instance_count = 1
      ami_id         = "ami-024c3652b28842b66"
      instance_type  = "t3.micro"
      instance_names = ["Ubuntu_Env1"]
    }
  ]
  #To create a S3 bucket resource with different configurations
  s3_configurations = [
    {
      bucket_name             = "tg-test-bucket1"
      bucket_versioning       = "Enabled"
      pass_bucket_policy_file = true
      bucket_policy_file_path = "./sample-s3-bucket-policy.json"
    },
    {
      bucket_name             = "tg-test-bucket2"
      bucket_versioning       = "Disabled"
      pass_bucket_policy_file = false
      bucket_policy_file_path = null
    }
  ]
}

#IAM module 
module "iam_role" {
  source             = "git@github.com:DISHDevEx/iot.git//aws/modules/iam?ref=sriharsha/test-tg-template"
  aws_region         = "us-east-1"
  iam_role_name      = "tg-test-role"
  assume_role_policy = <<-EOT
  {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ssm.amazonaws.com",
            "glue.amazonaws.com",
            "ec2.amazonaws.com",
            "lambda.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  }
  EOT

  iam_policy = <<-EOT
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
          },
          {
            "Action": "glue:StartJobRun",
            "Effect": "Allow",
            "Resource": "*"
          },
          {
            "Action": ["lambda:CreateFunction","lambda:DeleteFunction","lambda:GetFunction","lambda:GetFunctionConfiguration"],
            "Effect": "Allow",
            "Resource": "*"
          }
        ]
      }
    EOT

  iam_policy_name     = "iamroleInlinePolicy"
  permission_boundary = "arn:aws:iam::064047601590:policy/TaaSAdminDev_Permission_Boundary"
}

#EC2 module 
module "ec2_instance" {
  source                  = "git@github.com:DISHDevEx/iot.git//aws/modules/ec2?ref=sriharsha/test-tg-template"
  depends_on              = [module.iam_role]
  for_each                = { for index, config in local.ec2_configurations : index => config }
  instance_count          = each.value.instance_count
  ami_id                  = each.value.ami_id
  instance_type           = each.value.instance_type
  root_volume_type        = "gp3"
  root_volume_size        = 20
  root_volume_encrypted   = true
  root_volume_termination = true
  instance_names          = each.value.instance_names
  /*
  For the following variables, values can be assigned directly or they can be assigned via HashiCorp Vault data source.
  #Direct assignment:
  Example: iam_instance_profile_name = "xxxxxxxxxxx" #Provide respective IAM instance profile name.
  #Assignment via Vault:
  Example: iam_instance_profile_name = data.vault_generic_secret.getsecrets.data["iam_instance_profile_name"] #This works only if you had pre-configured this value in your vault instance.
  Note: Please don't commit any file with sensitive information to code repository or publicly accessible location.
  */
  iam_instance_profile_name = module.iam_role.iam_instance_profile_name
  key_pair_name             = "Leto_DishTaasAdminDev_EC2"
  subnet_id                 = "subnet-05b845545c737ac56"
  vpc_security_group_ids    = ["sg-09141b3415e566e1a"]
}

#S3 module
module "s3_bucket" {
  source                  = "git@github.com:DISHDevEx/iot.git//aws/modules/s3?ref=sriharsha/test-tg-template"
  for_each                = { for index, config in local.s3_configurations : index => config }
  bucket_name             = each.value.bucket_name
  bucket_versioning       = each.value.bucket_versioning
  pass_bucket_policy_file = each.value.pass_bucket_policy_file
  bucket_policy_file_path = each.value.bucket_policy_file_path
}

#Glue Job module
module "glue_job" {
  source                                = "git@github.com:DISHDevEx/iot.git//aws/modules/glue?ref=sriharsha/test-tg-template"
  depends_on                            = [module.iam_role]
  job_names                             = ["GluejobA", "GluejobB"]
  connections                           = []
  create_role                           = false
  role_arn                              = module.iam_role.iam_role_arn
  description                           = "IOT Glue job"
  glue_version                          = "3.0"
  max_retries                           = 0
  timeout                               = 60
  security_configuration                = ""
  worker_type                           = "G.1X"
  number_of_workers                     = 2
  script_location                       = "s3://dish-dp-us-east-1-064047601590-sc-artifacts/prometheus-s3-template/products/prometheus-s3/v8/glue/script/dpi-prometheus-to-s3/dpi-prometheus-to-s3-job.py"
  python_version                        = 3
  job_language                          = "python"
  class                                 = null
  extra_py_files                        = []
  extra_jars                            = []
  user_jars_first                       = null
  use_postgres_driver                   = null
  extra_files                           = []
  job_bookmark_option                   = "job-bookmark-disable"
  temp_dir                              = null
  enable_s3_parquet_optimized_committer = true
  enable_rename_algorithm_v2            = true
  enable_glue_datacatalog               = true
  enable_metrics                        = false
  enable_continuous_cloudwatch_log      = false
  enable_continuous_log_filter          = true
  continuous_log_stream_prefix          = null
  continuous_log_conversion_pattern     = null
  enable_spark_ui                       = false
  spark_event_logs_path                 = null
  additional_python_modules             = []
  max_concurrent_runs                   = 1
}

##Lambda Function module with existing IAM role
#module "lambda_function" {
#  source                 = "git@github.com:DISHDevEx/iot.git//aws/modules/lambda_function"
#  depends_on             = [module.iam_role]
#  lambda_function_name   = "tg_test_lambda"
#  flag_use_existing_role = true
#  filepath               = "./index.py.zip"
#  handler                = "index.handler"
#  runtime                = "python3.8"
#  lambda_role_name       = module.iam_role.iam_role_name
#  existing_role_arn      = module.iam_role.iam_role_arn
#  policy_count           = 0
#}

#Lambda Function using existing role
module "lambda_function" {
  source                                = "git@github.com:DISHDevEx/iot.git//aws/modules/lambda_function"
  lambda_function_name                  = "tg_test_lambda"
  filepath                              = "./index.py.zip"
  handler                               = "index.handler"
  runtime                               = "python3.8"
  flag_use_existing_role                = true
  existing_role_arn                     = "arn:aws:iam::064047601590:role/aws-controltower-CloudWatchLogsRole"
}

##Lambda Function using new role with new policies
#module "lambda_function" {
#  source                                = "git@github.com:DISHDevEx/iot.git//aws/modules/lambda_function"
#  lambda_function_name                  = "tg_test_lambda"
#  filepath                              = "./index.py.zip"
#  handler                               = "index.handler"
#  runtime                               = "python3.8"
#  flag_use_existing_role                = false
#  lambda_role_name                      = "test-role"
#  flag_use_existing_policy              = false
#  iam_policy_name                       = "test-policy"
#  new_iam_policy                        = <<-EOT
#    {
#      "Version": "2012-10-17",
#      "Statement": [
#        {
#          "Action": [
#              "lambda:Get*",
#              "lambda:List*",
#              "cloudwatch:GetMetricData",
#              "cloudwatch:ListMetrics"
#          ],
#          "Effect": "Allow",
#          "Resource": "*"
#        },
#        {
#            "Effect": "Allow",
#            "Action": [
#                "logs:DescribeLogStreams",
#                "logs:GetLogEvents",
#                "logs:FilterLogEvents",
#                "logs:StartQuery",
#                "logs:StopQuery",
#                "logs:DescribeQueries",
#                "logs:GetLogGroupFields",
#                "logs:GetLogRecord",
#                "logs:GetQueryResults"
#            ],
#            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
#        }
#      ]
#    }
#  EOT
#  permission_boundary = "arn:aws:iam::064047601590:policy/TaaSAdminDev_Permission_Boundary"
#}

##Lambda Function using new role with existing policies
#module "lambda_function" {
#  source                                = "git@github.com:DISHDevEx/iot.git//aws/modules/lambda_function"
#  lambda_function_name                  = "tg_test_lambda"
#  filepath                              = "./index.py.zip"
#  handler                               = "index.handler"
#  runtime                               = "python3.8"
#  flag_use_existing_role                = false
#  lambda_role_name                      = "test-role"
#  flag_use_existing_policy              = true
#  policy_count                          = 2
#  existing_iam_policy_arns              = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess", "arn:aws:iam::aws:policy/CloudWatchFullAccess"]
#  permission_boundary                   = "arn:aws:iam::064047601590:policy/TaaSAdminDev_Permission_Boundary"
#}

# VPC module
# module "vpc" {
#   source          = "git@github.com:DISHDevEx/iot.git//aws/modules/vpc?ref=sriharsha/test-tg-template"
#   vpc_name = "tg-test-vpc"
#   vpc_cidr_block = "10.5.128.0/18"
#   vpc_instance_tenancy = "default"
#   vpc_enable_dns_support = true
#   vpc_enable_dns_hostnames = true
#   vpc_assign_generated_ipv6_cidr_block = false

#   subnet_name = ["subnet1", "subnet2"]
#   subnet_cidr_block = ["10.5.132.0/24", "10.5.133.0/24"]
#   subnet_availability_zone = ["us-east-1a", "us-east-1b"]
#   subnet_map_public_ip_on_launch = false
#   subnet_assign_ipv6_address_on_creation = false

#   route_table_name = "route_table"
#   route_table_cidr_block = "10.5.128.0/18"
#   route_table_gateway_id = "local"

# }

#Security Group module
module "security-group" {
  source                     = "git@github.com:DISHDevEx/iot.git//aws/modules/security-group"
  security_group_name        = "sample-security-group"
  security_group_description = "security group for IOT Boat"
  ingress_port               = 443
  ingress_protocol           = "tcp"
  ingress_cidr_blocks        = ["0.0.0.0/32"]
  egress_port                = 0
  egress_protocol            = "-1"
  egress_cidr_blocks         = ["0.0.0.0/0"]
  vpc_id                     = "vpc-0eb0f6cc5c4f183c0"
}

# SQS module
module "sqs" {
  source                    = "git@github.com:DISHDevEx/iot.git//aws/modules/sqs?ref=sriharsha/test-tg-template"
  count                     = 1
  name                      = ["iot-tg-test-sqs"]
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 1440
  receive_wait_time_seconds = 0  
}
#

# EKS module
# module "eks_cluster" {
#   source                                       = "git@github.com:DISHDevEx/iot.git//aws/modules/eks_cluster"
#   flag_use_existing_vpc                        = true
#   existing_vpc_id                              = "vpc-0008ab497981ab238"
#   flag_use_existing_internet_gateway           = true
#   existing_internet_gateway_id                 = "igw-0c4f027b670ca5a20"
#   flag_use_existing_subnet                     = true
#   existing_private_subnet_ids                  = ["subnet-02ab758b4befd2ce7", "subnet-0a55963a1c93564e6"]
#   existing_public_subnet_ids                   = ["subnet-085f1229f0b4adc98", "subnet-09d1de6f2a3e91ea1"]
#   flag_use_existing_eip                        = true
#   existing_eip_id                              = "eipalloc-03b35452a7ba3c182"
#   flag_use_existing_nat_gateway                = true
#   existing_nat_gateway_id                      = "nat-0b9cf1112243356a8"
#   flag_use_existing_private_subnet_route_table = true
#   existing_private_subnet_route_table_id       = "rtb-025c46c5a32b3c3e2"
#   flag_use_existing_public_subnet_route_table  = true
#   existing_public_subnet_route_table_id        = "rtb-07d20cfcb778facfa"
#   flag_use_existing_eks_execution_role         = true
#   existing_eks_iam_role_arn                    = "arn:aws:iam::018300759195:role/cntf-open5gs-cluster-cluster-20230802184244723700000006"
#   flag_use_existing_node_group_role            = true
#   existing_node_group_iam_role_arn             = "arn:aws:iam::018300759195:role/default_node_group-eks-node-group-20230802184244449300000001"
#   eks_cluster_name                             = "eks_cluster"
#   eks_node_group_name                          = "eks_node"
#   eks_node_capacity_type                       = "ON_DEMAND"
#   eks_node_instance_types                      = ["t3.small"]
#   eks_node_desired_size                        = 1
#   eks_node_max_size                            = 5
#   eks_node_min_size                            = 0
#   eks_node_max_unavailable                     = 1
# }

#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#Modules with HashiCorp Vault
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#EC2 module with HashiCorp Vault
# module "ec2_instance" {
#   source                  = "git@github.com:DISHDevEx/iot.git//aws/modules/ec2"
#   for_each                = { for index, config in local.ec2_configurations : index => config }
#   instance_count          = each.value.instance_count
#   ami_id                  = each.value.ami_id
#   instance_type           = each.value.instance_type
#   root_volume_type        = "gp3"
#   root_volume_size        = 20
#   root_volume_encrypted   = true
#   root_volume_termination = true
#   instance_names          = each.value.instance_names
#   /*
#   For the following variables, values can be assigned directly or they can be assigned via HashiCorp Vault data source.
#   #Direct assignment:
#   Example: iam_instance_profile_name = "xxxxxxxxxxx" #Provide respective IAM role name.
#   #Assignment via Vault:
#   Example: iam_instance_profile_name = data.vault_generic_secret.getsecrets.data["iam_instance_profile_name"] #This works only if you had pre-configured this value in your vault instance.
#   Note: Please don't commit any file with sensitive information to code repository or publicly accessible location.
#   */
#   iam_instance_profile_name = data.vault_generic_secret.getsecrets.data["iam_instance_profile_name"]
#   key_pair_name             = data.vault_generic_secret.getsecrets.data["key_pair_name"]
#   subnet_id                 = data.vault_generic_secret.getsecrets.data["subnet_id"]
#   vpc_security_group_ids    = [data.vault_generic_secret.getsecrets.data["vpc_security_group_ids"]]
# }

# EKS module with existing vpc, subnets and route table
module "eks_cluster" {
  source                                       = "/Users/mariamanisha.miranda/Desktop/iot/aws/modules/eks_cluster"
  flag_use_existing_vpc                        = true
  existing_vpc_id                              = "vpc-0eb0f6cc5c4f183c0"
  flag_use_existing_subnet                     = true
  existing_subnet_ids                          = ["subnet-057c4020b8d00ac2d", "subnet-03bf51decd06148fc"]
  flag_use_existing_subnet_route_table         = true
  existing_subnet_route_table_id               = "rtb-09332b21e5feb567a"
  flag_use_existing_eks_execution_role         = true
  existing_eks_iam_role_arn                    = "arn:aws:iam::064047601590:role/mss-eks-cluster-role"
  flag_use_existing_node_group_role            = true
  existing_node_group_iam_role_arn             = "arn:aws:iam::064047601590:role/test_node_group_role"
  eks_cluster_name                             = "eks_cluster"
  eks_node_group_name                          = "eks_node"
  eks_node_capacity_type                       = "ON_DEMAND"
  eks_node_instance_types                      = ["t3.small"]
  eks_node_desired_size                        = 1
  eks_node_max_size                            = 5
  eks_node_min_size                            = 0
  eks_node_max_unavailable                     = 1
}

