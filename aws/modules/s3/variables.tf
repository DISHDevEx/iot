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
variable "pass_bucket_policy_file" {
  description = "If your want to pass bucket policy(json file), set this value to true. Else set this value to false."
  type        = bool
  default     = false
}
variable "bucket_policy_file_path" {
  description = "S3 bucket policy file path"
  type        = string
  default     = null
  sensitive   = true
}
variable "log_bucket" {
  description = "The name of the S3 bucket where logs will be stored"
  type        = string
}
