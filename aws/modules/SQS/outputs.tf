output "sqs_queue_id" {
  description = "The ID of the created sqs queue "
  value       = aws_sqs_queue.iot_terraform_queue.id
}