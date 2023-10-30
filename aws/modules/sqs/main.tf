resource "aws_sqs_queue" "iot_terraform_queue" {
  count                     = var.count_val
  name                      = var.name[count.index]
  delay_seconds             = var.delay_seconds
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
  # redrive_policy = jsonencode({
  #   deadLetterTargetArn     = var.deadLetterTargetArn
  #   maxReceiveCount         = var.maxReceiveCount
  # })

  tags = {
    Boat = "IOT"
  }
}