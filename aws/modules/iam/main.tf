#resources for IAM Role

resource "aws_iam_role" "IOT_role" {
  name                 = format("iot_%s", var.iam_role_name)
  assume_role_policy   = var.assume_role_policy
  permissions_boundary = var.permission_boundary
}

resource "aws_iam_role_policy" "iam_inline_policy" {
  name = var.iam_policy_name
  role = aws_iam_role.IOT_role.name

  policy = var.iam_policy
}


