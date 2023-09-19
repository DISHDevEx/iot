#Variables
#
variable "aws_access_key" {
  type      = string
  default   = null
  sensitive = true
}
variable "aws_secret_key" {
  type      = string
  default   = null
  sensitive = true
}
variable "aws_session_token" {
  type      = string
  default   = null
  sensitive = true
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "instance_count" {
  type    = number
  default = 1
}
variable "ami_id" {
  type    = string
  default = "ami-0a89b4f85b0b6f49c"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "aws_iam_role" {
  type      = string
  default   = null
  sensitive = true
}
variable "key_pair_name" {
  type      = string
  default   = null
  sensitive = true
}
variable "subnet_id" {
  type      = string
  default   = null
  sensitive = true
}
variable "vpc_security_group_ids" {
  type      = list(string)
  default   = null
  sensitive = true
}
variable "instance_names" {
  type    = list(string)
  default = null
}
variable "hcp_client_id" {
  type      = string
  default   = null
  sensitive = true
}
variable "hcp_client_secret" {
  type      = string
  default   = null
  sensitive = true
}
variable "hcp_vault_app_name" {
  type      = string
  default   = null
  sensitive = true
}