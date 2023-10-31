output "sqs_queue_id" {
  description = "The ID of the created sqs queue "
  value       = "Index" + { for k, v in aws_sqs_queue.iot_terraform_queue : k => v.id }
}