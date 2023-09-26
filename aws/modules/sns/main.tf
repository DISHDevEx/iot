resource "aws_sns_topic" "iot_sns" {
  name  = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "user_updates_sns" {

  topic_arn = aws_sns_topic.iot_sns.arn
  protocol  = "email"
  endpoint  = "anaghaa.londhe@dish.com"
}

resource "aws_sns_topic_policy" "iot_sns_policy" {
  arn = aws_sns_topic.iot_sns.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission"
    ]

    effect = "Allow"


    resources = [
      aws_sns_topic.iot_sns.arn,
    ]
  }
}