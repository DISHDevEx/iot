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
#Backend variables
variable "backend_bucket_name" {
  description = "Backend S3 bucket name to store the Terraform state file"
  type        = string
  default     = null
  sensitive   = true
}
variable "backend_bucket_key" {
  description = "Backend S3 file to store the Terraform state file"
  type        = string
  default     = null
  sensitive   = true
}
variable "backend_dynamodb_table_name" {
  description = "Backend Dynamodb table name to store the Terraform state lock"
  type        = string
  default     = null
  sensitive   = true
}