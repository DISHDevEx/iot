#Assigning the local region variable
data "aws_region" "current" {
}


#Assigning the local account id
data "aws_caller_identity" "current" {
}

# Create Lambda Function
resource "aws_lambda_function" "iot_lambda_template" {
  filename         = var.filepath
  function_name    = "${var.resource_prefix}${var.lambda_function_name}"
  role             = var.flag_use_existing_role ? var.existing_role_arn : module.iam[0].iam_role_arn
  handler          = var.handler

#  source_code_hash = filebase64sha256(var.filepath)

  runtime          = var.runtime

  environment {
    variables = {
      "local_region" = data.aws_region.current.name,
      "account_id"   = data.aws_caller_identity.current.account_id
    }
  }

  tags = {
    Name = var.lambda_function_name
  }
}


module "iam" {
  count                    = var.flag_use_existing_role ? 0 : 1
  source                   = "git@github.com:DISHDevEx/iot.git//aws/modules/iam"
  aws_region               = data.aws_region.current.name
  iam_role_name            = var.lambda_role_name
  assume_role_policy       = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  iam_policy_name          = var.flag_use_existing_policy ? null : var.iam_policy_name
  iam_policy               = var.flag_use_existing_policy ? null : var.new_iam_policy
  flag_use_existing_policy = var.flag_use_existing_policy
  policy_count             = var.policy_count
  existing_iam_policy_arns = var.existing_iam_policy_arns
  permission_boundary      = var.permission_boundary
}
