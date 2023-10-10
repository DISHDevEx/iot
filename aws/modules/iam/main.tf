# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }
# }

# provider "aws" {
#   region = var.aws_region
# }

#resources for IAM Role

resource "aws_iam_role" "IOT_role" {
  name = var.iam_role_name

  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy" "glue_and_ec2_inline_policy" {
  name        = var.iam_policy_name
  role = aws_iam_role.IOT_role.name
  # description = var.iam_policy_description
  
  policy = var.iam_policy
}


