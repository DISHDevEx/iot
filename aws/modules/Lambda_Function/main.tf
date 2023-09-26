#Assigning the local region variable
data "aws_region" "current" {
}


#Assigning the local account id
data "aws_caller_identity" "current" {
}


# Create Lambda Function

resource "aws_lambda_function" "iot_lambda_template" {
  filename         = var.filepath
  function_name    = var.function_name
  role             = var.role_arn
  handler          = var.handler

  source_code_hash = filebase64sha256(var.filepath)

  runtime          = var.runtime

  environment {
    variables = {
      "local_region" = data.aws_region.current.name,
      "account_id" = data.aws_caller_identity.current.account_id
    }
  }

  tags = {
    Name = var.function_name
  }
}

