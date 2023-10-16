#Variables
variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = null
}
variable "bucket_versioning" {
  description = "Flag value to either enable or disable versioning for object in S3 bucket"
  type        = string
  default     = "Enabled"
}
variable "aws_account_id" {
  description = "AWS account id to be used in the S3 bucket policy - Principal"
  type        = number
  default     = null
}
variable "bucket_policy_file_path" {
  description = "S3 bucket policy file path"
  type        = string
  default     = "git@github.com:DISHDevEx/iot.git//aws/modules/s3/default-s3-bucket-policy.json?ref=sriharsha/s3"
  sensitive   = true
}