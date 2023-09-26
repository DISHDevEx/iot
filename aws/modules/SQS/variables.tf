variable "name" {
  description = "Name for the SQS Queue"
  type = string
  default = "iot_sqs_queue_template"
}

variable "delay_seconds" {
  description = "Time the delivery of messages delayed in queue"
  type = number
  default = "0"
}

variable "message_retention_seconds" {
  description = "Seconds SQS retains a message"
  type = number
  default = "345600"
}

variable "receive_wait_time_seconds" {
  description = "Seconds ReceiveMessage call will wait for message to arrive"
  type = number
  default = "0"
}

variable "max_message_size" {
  description = "Byte limit of the message"
  type = number
  default = "262144"
}

variable "deadLetterTargetArn" {
  description = "Arn of the other queue when the main queue fails"
  type = string
  default = null
}

variable "maxReceiveCount" {
  description = "The max recieve count"
  type = number
  default = 5
}