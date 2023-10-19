variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "iam_role_name"{
  type    = string
  default = "IOTrole"
}
variable "assume_role_policy"{
  type    = string
  default = <<EOF
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
EOF
}

variable "iam_policy_name"{
  type    = string
  default = "GlueAndEC2InlinePolicy"
}

variable "iam_policy_description"{
  type    = string
  default = "Inline policy for Glue job and EC2 instances"
}

variable "iam_policy" {
  type = string
  default = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "ec2:Describe*",
          "Effect": "Allow",
          "Resource": "*"
        },
        {
          "Action": "glue:StartJobRun",
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
    }
  EOT
}

variable "permission_boundary" {
  type = string
  default = "arn:aws:iam::064047601590:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_DishTaasAdminDev_ea612f790bd52334"
}