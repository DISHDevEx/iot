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
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
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