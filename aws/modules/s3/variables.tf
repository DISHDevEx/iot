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
  description = "AWS account id required for principal input in s3 policy file"
  type        = string
  default     = null
  sensitive   = true
}
variable "bucket_policy_file_path" {
  description = "S3 bucket policy file path"
  type        = string
  default     = "./s3-policy-default.json"
  sensitive   = true
}