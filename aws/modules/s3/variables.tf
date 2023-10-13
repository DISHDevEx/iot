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
#Note: 'bucket_policy_file_path' is a 'Optional' variable
variable "bucket_policy_file_path" {
  description = "S3 bucket policy file path"
  type        = string
  default     = null
}