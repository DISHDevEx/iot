/*
Terraform configuration for all modules.
*/
#Locals
locals {
  #   #To create a EC2 resource with different configurations
  #   ec2_configurations = [
  #     {
  #       instance_count = 2
  #       ami_id         = "ami-0a89b4f85b0b6f49c"
  #       instance_type  = "t2.micro"
  #       instance_names = ["Linux_Env1", "Linux_Env2"]
  #     },
  #     {
  #       instance_count = 2
  #       ami_id         = "ami-024c3652b28842b66"
  #       instance_type  = "t3.micro"
  #       instance_names = ["Ubuntu_Env1", "Ubuntu_Env2"]
  #     }
  #   ]
  #To create a S3 bucket resource with different configurations
  s3_configurations = [
    {
      bucket_name       = "sriharsha-bucket1"
      bucket_versioning = "Enabled"
    },
    {
      bucket_name       = "sriharsha-bucket2"
      bucket_versioning = "Enabled"
    }
  ]
}

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
#   Example: iam_role = "xxxxxxxxxxx" #Provide respective IAM role name.
#   #Assignment via Vault:
#   Example: iam_role = data.vault_generic_secret.getsecrets.data["iam_role"] #This works only if you had pre-configured this value in your vault instance.
#   Note: Please don't commit any file with sensitive information to code repository or publicly accessible location.
#   */
#   iam_role               = data.vault_generic_secret.getsecrets.data["iam_role"]
#   key_pair_name          = data.vault_generic_secret.getsecrets.data["key_pair_name"]
#   subnet_id              = data.vault_generic_secret.getsecrets.data["subnet_id"]
#   vpc_security_group_ids = [data.vault_generic_secret.getsecrets.data["vpc_security_group_ids"]]
# }

#S3 module without HashiCorp Vault
module "s3_bucket" {
  source                  = "git@github.com:DISHDevEx/iot.git//aws/modules/s3?ref=sriharsha/s3"
  for_each                = { for index, config in local.s3_configurations : index => config }
  bucket_name             = each.value.bucket_name
  bucket_versioning       = each.value.bucket_versioning
}

#Glue module without HashiCorp Vault
# module "glue_job" {
#   source          = "git@github.com:DISHDevEx/iot.git//aws/modules/glue"
#   job_names       = ["xxxxxx"]
#   role_arn        = "xxxxxxxx"
#   script_location = "xxxxxxxx"
# }

#Lambda Function module without HashiCorp Vault
# module "lambda_function" {
#   source        = "git@github.com:DISHDevEx/iot.git//aws/modules/lambda_function"
#   function_name = "iot_sample_lambda"
#   filepath      = "Enter zip file path"
#   handler       = "index.handler"
#   runtime       = "python3.8"
#   role_arn      = "xxxxxxxxxxxx"
# }

#Security Group module without HashiCorp Vault
# module "security-group" {
#   source                     = "git@github.com:DISHDevEx/iot.git//aws/modules/security-group""
#   security_group_name        = "Enter security group name"
#   security_group_description = "Enter description for the security group"
#   ingress_port               = xxxx
#   ingress_cidr_blocks        = ["xxxxxxxxx"]
# }