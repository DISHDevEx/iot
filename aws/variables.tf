#Variables for root module
variable "aws_region" {
  description = "AWS region for resources management"
  type        = string
  default     = "us-east-1"
}
variable "aws_access_key" {
  description = "AWS region for resources management"
  type        = string
  default     = null
}
variable "aws_secret_key" {
  description = "AWS region for resources management"
  type        = string
  default     = null
}
variable "aws_session_token" {
  description = "AWS region for resources management"
  type        = string
  default     = null
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