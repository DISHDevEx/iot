/*
Terraform configuration for all modules.
*/
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#Modules without HashiCorp Vault
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
##Locals
# locals {
#   #To create a EC2 resource with different configurations
#   ec2_configurations = [
#     {
#       instance_count = 1
#       ami_id         = "ami-0a89b4f85b0b6f49c"
#       instance_type  = "t2.micro"
#       instance_names = ["Linux_Env1"]
#     },
#     {
#       instance_count = 1
#       ami_id         = "ami-024c3652b28842b66"
#       instance_type  = "t3.micro"
#       instance_names = ["Ubuntu_Env1"]
#     }
#   ]
#   #To create a S3 bucket resource with different configurations
#   s3_configurations = [
#     {
#       #Note that a prefix 'iot-' will be added to the bucket name in the background automatically. Example: "tg-test-bucket1" will be converted to "iot-tg-test-bucket1"
#       bucket_name             = "tg-test-bucket1" 
#       bucket_versioning       = "Enabled"
#       pass_bucket_policy_file = true
#       bucket_policy_file_path = "./sample-s3-bucket-policy.json"
#     },
#     {
#       bucket_name             = "tg-test-bucket2"
#       bucket_versioning       = "Disabled"
#       pass_bucket_policy_file = false
#       bucket_policy_file_path = null
#     }
#   ]
# }

##S3 module
# module "s3_bucket" {
#   source                  = "git@github.com:DISHDevEx/iot.git//aws/modules/s3"
#   for_each                = { for index, config in local.s3_configurations : index => config }
#   bucket_name             = each.value.bucket_name
#   bucket_versioning       = each.value.bucket_versioning
#   pass_bucket_policy_file = each.value.pass_bucket_policy_file
#   bucket_policy_file_path = each.value.bucket_policy_file_path
# }

##EC2 module 
# module "ec2_instance" {
#   source                  = "git@github.com:DISHDevEx/iot.git//aws/modules/ec2"
#   #depends_on              = [module.iam_role] #This line is not required, if you are passing the 'iam_instance_profile_name' variable value directly
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
#   Example: iam_instance_profile_name = "xxxxxxxxxxx" #Provide respective IAM instance profile name.
#   #Assignment via Vault:
#   Example: iam_instance_profile_name = data.vault_generic_secret.getsecrets.data["iam_instance_profile_name"] #This works only if you had pre-configured this value in your vault instance.
#   Note: Please don't commit any file with sensitive information to code repository or publicly accessible location.
#   */
#   #You can either pass iam_instance_profile_name value directly as "ssm-role-5g-dp-dev" or use the 'iam' module output as module.iam_role.iam_instance_profile_name
#   iam_instance_profile_name = "ssm-role-5g-dp-dev"
#   key_pair_name             = "Leto_DishTaasAdminDev_EC2"
#   subnet_id                 = "subnet-05b845545c737ac56"
#   vpc_security_group_ids    = ["sg-09141b3415e566e1a"]
# }

##EKS module
# module "eks_cluster" {
#   source                                       = "git@github.com:DISHDevEx/iot.git//aws/modules/eks_cluster"
#   flag_use_existing_vpc                        = true
#   existing_vpc_id                              = "vpc-0eb0f6cc5c4f183c0"
#   flag_use_existing_subnet                     = true
#   existing_subnet_ids                          = ["subnet-057c4020b8d00ac2d", "subnet-03bf51decd06148fc"]
#   flag_use_existing_subnet_route_table         = true
#   existing_subnet_route_table_id               = "rtb-09332b21e5feb567a"
#   flag_use_existing_eks_execution_role         = true
#   existing_eks_iam_role_arn                    = "arn:aws:iam::064047601590:role/mss-eks-cluster-role"
#   flag_use_existing_node_group_role            = true
#   existing_node_group_iam_role_arn             = "arn:aws:iam::064047601590:role/test_node_group_role"
#   eks_cluster_name                             = "eks_cluster"
#   eks_node_group_name                          = "eks_node"
#   eks_node_capacity_type                       = "ON_DEMAND"
#   eks_node_instance_types                      = ["t3.small"]
#   eks_node_desired_size                        = 1
#   eks_node_max_size                            = 5
#   eks_node_min_size                            = 0
#   eks_node_max_unavailable                     = 1
# }

##Lambda Function using existing IAM role
# module "lambda_function" {
#   source                 = "git@github.com:DISHDevEx/iot.git//aws/modules/lambda_function"
#   #depends_on             = [module.iam_role] #This line is not required, if you are passing the 'existing_role_arn' variable value directly
#   lambda_function_name   = "tg_test_lambda"
#   filepath               = "./index.py.zip"
#   handler                = "index.handler"
#   runtime                = "python3.8"
#   flag_use_existing_role = true
#   #You can either pass existing role arn as "arn:aws:iam::064047601590:role/iot-test-lambda-role" or use the 'iam' module output as module.iam_role.iam_role_arn
#   existing_role_arn      = "arn:aws:iam::064047601590:role/iot-test-lambda-role" 
# }

##Lambda Function using new role with new policies
# module "lambda_function" {
#  source                    = "git@github.com:DISHDevEx/iot.git//aws/modules/lambda_function"
#  lambda_function_name     = "tg_test_lambda"
#  filepath                 = "./index.py.zip"
#  handler                  = "index.handler"
#  runtime                  = "python3.8"
#  flag_use_existing_role   = false
#  lambda_role_name         = "test-role"
#  flag_use_existing_policy = false
#  iam_policy_name          = "test-policy"
#  new_iam_policy           = <<-EOT
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
# }

##Lambda Function using new role with existing policies
# module "lambda_function" {
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
# }

##Security Group module
# module "security-group" {
#   source                     = "git@github.com:DISHDevEx/iot.git//aws/modules/security-group"
#   security_group_name        = "sample-security-group"
#   security_group_description = "security group for IOT Boat"
#   ingress_port               = 443
#   ingress_protocol           = "tcp"
#   ingress_cidr_blocks        = ["0.0.0.0/32"]
#   egress_port                = 0
#   egress_protocol            = "-1"
#   egress_cidr_blocks         = ["0.0.0.0/0"]
#   vpc_id                     = "vpc-0eb0f6cc5c4f183c0"
# }

##IAM module 
# module "iam_role" {
#   source             = "git@github.com:DISHDevEx/iot.git//aws/modules/iam"
#   aws_region         = "us-east-1"
#   iam_role_name      = "tg-test-role"
#   assume_role_policy = <<-EOT
#   {
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Principal" : {
#           "Service" : [
#             "ssm.amazonaws.com",
#             "glue.amazonaws.com",
#             "ec2.amazonaws.com",
#             "lambda.amazonaws.com"
#           ]
#         },
#         "Action" : "sts:AssumeRole"
#       }
#     ]
#   }
#   EOT

#   iam_policy = <<-EOT
#       {
#         "Version": "2012-10-17",
#         "Statement": [
#           {
#             "Action": "ec2:*",
#             "Effect": "Allow",
#             "Resource": "*"
#           },
#           {
#             "Action": "glue:StartJobRun",
#             "Effect": "Allow",
#             "Resource": "*"
#           },
#           {
#             "Action": ["lambda:CreateFunction","lambda:DeleteFunction","lambda:GetFunction","lambda:GetFunctionConfiguration"],
#             "Effect": "Allow",
#             "Resource": "*"
#           }
#         ]
#       }
#     EOT

#   iam_policy_name     = "iamroleInlinePolicy"
#   permission_boundary = "arn:aws:iam::064047601590:policy/TaaSAdminDev_Permission_Boundary"
# }

##Glue Job module
# module "glue_job" {
#   source                                = "git@github.com:DISHDevEx/iot.git//aws/modules/glue"
#   #depends_on                            = [module.iam_role] #This line is not required, if you are passing the 'role_arn' variable value directly
#   job_names                             = ["GluejobA", "GluejobB"]
#   connections                           = []
#   create_role                           = false
#   #You can either pass role_arn value directly as "arn:aws:iam::064047601590:role/dpi-radcom-be-glue-prometheus-us-east-1-role" or use the 'iam' module output as module.iam_role.iam_role_arn
#   role_arn                              = "arn:aws:iam::064047601590:role/dpi-radcom-be-glue-prometheus-us-east-1-role"
#   description                           = "IOT Glue job"
#   glue_version                          = "3.0"
#   max_retries                           = 0
#   timeout                               = 60
#   security_configuration                = ""
#   worker_type                           = "G.1X"
#   number_of_workers                     = 2
#   script_location                       = "s3://dish-dp-us-east-1-064047601590-sc-artifacts/prometheus-s3-template/products/prometheus-s3/v8/glue/script/dpi-prometheus-to-s3/dpi-prometheus-to-s3-job.py"
#   python_version                        = 3
#   job_language                          = "python"
#   class                                 = null
#   extra_py_files                        = []
#   extra_jars                            = []
#   user_jars_first                       = null
#   use_postgres_driver                   = null
#   extra_files                           = []
#   job_bookmark_option                   = "job-bookmark-disable"
#   temp_dir                              = null
#   enable_s3_parquet_optimized_committer = true
#   enable_rename_algorithm_v2            = true
#   enable_glue_datacatalog               = true
#   enable_metrics                        = false
#   enable_continuous_cloudwatch_log      = false
#   enable_continuous_log_filter          = true
#   continuous_log_stream_prefix          = null
#   continuous_log_conversion_pattern     = null
#   enable_spark_ui                       = false
#   spark_event_logs_path                 = null
#   additional_python_modules             = []
#   max_concurrent_runs                   = 1
# }

##Sagemaker module
# module "sagemaker" {
#   source                                                     = "git@github.com:DISHDevEx/iot.git//aws/modules/sagemaker"
#   enable_sagemaker_notebook_instance                         =  true
#   sagemaker_notebook_instance_name                           =  "iot-sagemaker"
#   sagemaker_notebook_instance_role_arn                       =  "arn:aws:iam::064047601590:role/SagemakerEMRNoAuthProductWi-SageMakerExecutionRole-1KF4KOLT4YA6A"
#   sagemaker_notebook_instance_instance_type                  =  "ml.t2.medium"
#   sagemaker_notebook_instance_subnet_id                      =  null
#   sagemaker_notebook_instance_security_groups                =  null
#   sagemaker_notebook_instance_kms_key_id                     =  null
#   sagemaker_notebook_instance_lifecycle_config_name          =  null
#   sagemaker_notebook_instance_direct_internet_access         =  null
#   sagemaker_notebook_volume-size                             =  5
#   enable_sagemaker_notebook_instance_lifecycle_configuration =  false
#   tags                                                       =  {}
# }

## SQS module
# module "sqs" {
#   source                    = "git@github.com:DISHDevEx/iot.git//aws/modules/sqs"
#   count                     = 1
#   name                      = ["iot-tg-test-sqs"]
#   delay_seconds             = 0
#   max_message_size          = 262144
#   message_retention_seconds = 1440
#   receive_wait_time_seconds = 0  
# }

##VPC module
# module "vpc" {
#   source = "git@github.com:DISHDevEx/iot.git//aws/modules/vpc"
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

#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#Modules with HashiCorp Vault
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
##EC2 module with HashiCorp Vault
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

