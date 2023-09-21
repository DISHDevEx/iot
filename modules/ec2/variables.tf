#Variables
#
variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default     = null
  sensitive   = true
}
variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default     = null
  sensitive   = true
}
variable "aws_session_token" {
  description = "AWS session token"
  type        = string
  default     = null
  sensitive   = true
}
variable "aws_region" {
  description = "AWS region name"
  type        = string
  default     = "us-east-1"
}
variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}
variable "ami_id" {
  description = "Amazon Machine Image(AMI) Id"
  type        = string
  default     = "ami-0a89b4f85b0b6f49c"
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
variable "aws_iam_role" {
  description = "IAM role for EC2 instance"
  type        = string
  default     = null
  sensitive   = true
}
variable "key_pair_name" {
  description = "Keypair for EC2 instance"
  type        = string
  default     = null
  sensitive   = true
}
variable "subnet_id" {
  description = "Subnet for EC2 instance"
  type        = string
  default     = null
  sensitive   = true
}
variable "vpc_security_group_ids" {
  description = "Security group for EC2 instance"
  type        = list(string)
  default     = null
  sensitive   = true
}
variable "instance_names" {
  description = "Names for EC2 instances"
  type        = list(string)
  default     = null
}
variable "hcp_client_id" {
  description = "HashiCorp cloud platform client id"
  type        = string
  default     = null
  sensitive   = true
}
variable "hcp_client_secret" {
  description = "HashiCorp cloud platform client secret"
  type        = string
  default     = null
  sensitive   = true
}
variable "hcp_vault_app_name" {
  description = "HashiCorp cloud platform - Vault application name"
  type        = string
  default     = null
  sensitive   = true
}