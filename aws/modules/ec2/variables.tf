#Variables
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
variable "root_volume_type" {
  description = "EC2 - Root volume type"
  type        = string
  default     = "gp2"  
}
variable "root_volume_size" {
  description = "EC2 - Root volume size in GiB"
  type        = number
  default     = 15
}
variable "root_volume_encrypted" {
  description = "Boolean value to opt-in/opt-out root volume encryption during EC2 creation"
  type        = bool
  default     = true 
}
variable "root_volume_termination" {
  description = "Boolean value to opt-in/opt-out root volume termination during EC2 termination"
  type        = bool
  default     = true 
}
variable "iam_role" {
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
variable "vault_address" {
  description = "HashiCorp Vault address"
  type        = string
  default     = null
  sensitive   = true
}
variable "vault_token" {
  description = "HashiCorp Vault token"
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