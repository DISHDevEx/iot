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
  name = var.name

  assume_role_policy = var.assume_role_policy
}


resource "aws_iam_role_policy_attachment" "IOT_attachment" {
  role       = aws_iam_role.IOT_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


