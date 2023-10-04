#Variables for root module
variable "aws_region" {
  description = "AWS region name"
  type        = string
  default     = "us-east-1"
}
variable "aws_access_key" {
  description = "AWS account access key"
  type        = string
  default     = null
  sensitive   = true
}
variable "aws_secret_key" {
  description = "AWS account secret key"
  type        = string
  default     = null
  sensitive   = true
}
variable "aws_session_token" {
  description = "AWS account session token"
  type        = string
  default     = null
  sensitive   = true
}
variable "profile" {
  description = "AWS account - credentials profile name"
  type        = string
  default     = null
  sensitive   = true
}
variable "bucket_name" {
  description = "Backend S3 bucket name"
  type        = string
  default     = null
  sensitive   = true
}
variable "bucket_key" {
  description = "Terraform state file name in backend S3 bucket"
  type        = string
  default     = null
  sensitive   = true
}
variable "dynamodb_table_name" {
  description = "DynamoDB table name - used for state locking"
  type        = string
  default     = null
  sensitive   = true
}
variable "vault_address" {
  description = "Vault server address"
  type        = string
  default     = null
  sensitive   = true
}
variable "vault_token" {
  description = "Vault server token"
  type        = string
  default     = null
  sensitive   = true
}
variable "vault_secrets_path" {
  description = "Secrets path in Hashicorp Vault"
  type        = string
  default     = null
  sensitive   = true
}