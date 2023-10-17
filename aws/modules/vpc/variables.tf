variable "vpc_name" {
  description = "Assign a name to the VPC."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The IPv4 address range for the VPC."
  type        = string
}

variable "vpc_instance_tenancy" {
  description = "Tenancy options for instances launched into the VPC."
  type        = string
}

variable "vpc_enable_dns_support" {
  description = "Enable DNS support within the VPC."
  type        = bool
}

variable "vpc_enable_dns_hostnames" {
  description = "Enable DNS hostnames within the VPC."
  type        = bool
}

variable "vpc_assign_generated_ipv6_cidr_block" {
  description = "Assign a generated IPv6 CIDR block to the VPC."
  type        = bool
}

variable "subnet_name" {
  description = "Assign a name to the VPC."
  type        = list(string)
}

variable "subnet_cidr_block" {
  description = "The IPv4 address range for the subnet."
  type        = list(string)
}

variable "subnet_availability_zone" {
  description = "The desired availability zone for the subnet."
  type        = list(string)
}

variable "subnet_map_public_ip_on_launch" {
  description = "Map public IP addresses to instances launched in this subnet."
  type        = bool
}

variable "subnet_assign_ipv6_address_on_creation" {
  description = "Assign an IPv6 address to instances launched in this subnet."
  type        = bool
}

variable "route_table_name" {
  description = "The name of the route table."
  type        = string
}

variable "route_table_cidr_block" {
  description = "The CIDR block for the default route."
  type        = string
}

variable "route_table_gateway_id" {
  description = "The ID of the internet gateway to associate with the route table."
  type        = string
}

