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
  role             = var.flag_use_existing_role ? var.existing_role_arn : aws_iam_role.lambda_execution_role[0].arn
  handler          = var.handler

#  source_code_hash = filebase64sha256(var.filepath)

  runtime          = var.runtime

  environment {
    variables = {
      "local_region" = data.aws_region.current.name,
      "account_id" = data.aws_caller_identity.current.account_id
    }
  }

  tags = {
    Name = var.lambda_function_name
  }
}

# If the developer chooses to create a new IAM role, define it here
resource "aws_iam_role" "lambda_execution_role" {
  count = var.flag_use_existing_role ? 0 : 1
  name = "${var.resource_prefix}${var.lambda_role_name}"

  assume_role_policy = <<EOF
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
}

