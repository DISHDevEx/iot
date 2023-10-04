
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "security_group_name" {
  description = "Name for the security group"
  type        = string
}

variable "security_group_prefix" {
  description = "Prefix to be added to the resource name"
  default     = "iot-"
}

variable "security_group_description" {
  description = "Description for the security group"
  type        = string
  default     = "Sample Security Group"
}

###########
## Ingress
###########
variable "ingress_port" {
  description = "Port to control Inbound traffic"
  type        = number
  sensitive   = true
}

variable "ingress_protocol" {
  description = "Ingress Protocol"
  type        = string
  sensitive   = true
}

variable "ingress_cidr_blocks" {
  description = "IPv4 address range in CIDR format to use on all ingress rules"
  type        = list(string)
  sensitive   = true
}

variable "ingress_source_security_group_id" {
  description = "The existing security group id that the new security group wants to refer as source "
  type        = list(string)
  default     = null
  sensitive   = true
}

##########
## Egress
##########

variable "egress_port" {
  description = "Port to control Outbound traffic"
  type        = number
  sensitive   = true
}

variable "egress_protocol" {
  description = "Egress protocol"
  sensitive   = true
}

variable "egress_cidr_blocks" {
  description = "IPv4 address range in CIDR format to use on all ingress rules"
  type        = list(string)
  sensitive   = true
}

variable "egress_destination_security_group_id" {
  description = "The existing security group id that the new security group wants to refer as destination "
  type        = list(string)
  default     = null
  sensitive   = true
}

