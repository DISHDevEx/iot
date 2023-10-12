#Variables
variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = null
}
variable "aws_region" {
  description = "AWS region in which the bucket resides"
  type        = string
  default     = "us-east-1"
}
variable "object_versioning" {
  description = "Flag value to either enable or disable versioning for object in S3 bucket"
  type        = string
  default     = "Enabled"
}