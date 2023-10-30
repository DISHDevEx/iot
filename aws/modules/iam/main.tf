#resources for IAM Role

resource "aws_iam_role" "IOT_role" {
  name = var.iam_role_name
  assume_role_policy = var.assume_role_policy
  permissions_boundary = "arn:aws:iam::064047601590:policy/TaaSAdminDev_Permission_Boundary"
}

resource "aws_iam_role_policy" "glue_and_ec2_inline_policy" {
  count       = var.flag_use_existing_policy ? 0 : 1
  name        = var.iam_policy_name
  role        = aws_iam_role.IOT_role.name
  
  policy = var.iam_policy
}

#Attach IAM Policy to IAM role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  count       = var.policy_count * (var.flag_use_existing_policy ? 1 : 0)
  role        = aws_iam_role.IOT_role.name
  policy_arn  = var.existing_iam_policy_arns[count.index]
}
