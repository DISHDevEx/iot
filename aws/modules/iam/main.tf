#resources for IAM Role

resource "aws_iam_role" "IOT_role" {
  name                 = format("iot_%s", var.iam_role_name)
  assume_role_policy   = var.assume_role_policy
  permissions_boundary = var.permission_boundary
}

resource "aws_iam_role_policy" "iam_inline_policy" {
  count= var.flag_use_existing_policy ? 0 : 1
  name = var.iam_policy_name
  role = aws_iam_role.IOT_role.name

  policy = var.iam_policy
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = aws_iam_role.IOT_role.name
  role = aws_iam_role.IOT_role.name
}

#Attach IAM Policy to IAM role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  count       = var.policy_count * (var.flag_use_existing_policy ? 1 : 0)
  role        = aws_iam_role.IOT_role.name
  policy_arn  = var.existing_iam_policy_arns[count.index]
}
