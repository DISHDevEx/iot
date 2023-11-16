output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = aws_sns_topic.iot-sns-topic-template.arn
}

output "subscription_arn" {
  description = "ARN of the subscription"
  value       = aws_sns_topic_subscription.iot-sns-topic-subscription.arn
}

output "subscription_confirmation" {
  description = "Whether the subscription has not been confirmed."
  value       = aws_sns_topic_subscription.iot-sns-topic-subscription.pending_confirmation
}

