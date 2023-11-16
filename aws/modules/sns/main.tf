#Create AWS SNS Topic
resource "aws_sns_topic" "iot-sns-topic-template" {
  name = "${var.sns_topic_name_prefix}${var.sns_topic_name}"
  display_name = var.display_name
  delivery_policy = var.delivery_policy
  fifo_topic = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication
  tracing_config = var.tracing_config
  application_success_feedback_role_arn = var.application_success_feedback_role_arn
  application_failure_feedback_role_arn = var.application_success_feedback_role_arn
  lambda_failure_feedback_role_arn = var.lambda_failure_feedback_role_arn
  lambda_success_feedback_role_arn = var.lambda_success_feedback_role_arn
  sqs_failure_feedback_role_arn = var.sqs_failure_feedback_role_arn
  sqs_success_feedback_role_arn = var.sqs_success_feedback_role_arn

  tags = {
    Name = var.sns_topic_name
  }
}


#Create SNS Topic Subscription
resource "aws_sns_topic_subscription" "iot-sns-topic-subscription" {
  topic_arn = aws_sns_topic.iot-sns-topic-template.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
  subscription_role_arn = var.subscription_role_arn
  confirmation_timeout_in_minutes = var.confirmation_timeout
  filter_policy = var.filter_policy
  filter_policy_scope = var.filter_policy_scope

  depends_on = [aws_sns_topic.iot-sns-topic-template]
}
