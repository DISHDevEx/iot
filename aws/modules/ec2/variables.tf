#Variables
#
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "instance_count" {
  type    = number
  default = 1
}
variable "ami" {
  type    = string
  default = "ami-0a89b4f85b0b6f49c"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "instance_name" {
  type    = list(string)
  default = null
}
variable "hashicorp_vault_app_name" {
  type    = string
  default = null  
}