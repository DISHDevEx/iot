#resources for IAM Role

resource "aws_iam_role" "IOT_role" {
  name = var.iam_role_name
  assume_role_policy = var.assume_role_policy
  permissions_boundary = "arn:aws:iam::827704904976:policy/MarketPlace-Permission-Boundary"
}

resource "aws_iam_role_policy" "glue_and_ec2_inline_policy" {
  name        = var.iam_policy_name
  role = aws_iam_role.IOT_role.name
  # description = var.iam_policy_description
  
  policy = var.iam_policy
}


