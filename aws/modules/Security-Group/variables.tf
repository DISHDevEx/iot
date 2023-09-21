
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "security_group_name" {
  description = "Name for the security group"
  type        = string
  default = "sample_security_group"
}

variable "security_group_description" {
  description = "Description for the security group"
  type        = string
  default = "Sample Security Group"
}

###########
## Ingress
###########
variable "ingress_port" {
  description = "Port to control Inbound traffic"
  type        = number
  default = 443
}

variable "ingress_protocol" {
  description = "Ingress Protocol"
  type        = number
  default = "tcp"
}

variable "ingress_cidr_blocks" {
  description = "IPv4 address range in CIDR format to use on all ingress rules"
  type        = list(string)
  default = ["0.0.0.0/0"]
}

##########
## Egress
##########

variable "egress_port" {
  description = "Port to control Outbound traffic"
  type        = number
  default = 0
}

variable "egress_protocol" {
  description = "Egress protocol"
  type        = number
  default = "-1"
}

variable "egress_cidr_blocks" {
  description = "IPv4 address range in CIDR format to use on all ingress rules"
  type        = list(string)
  default = ["0.0.0.0/0"]
}

