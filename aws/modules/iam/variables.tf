variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "name"{
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
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

