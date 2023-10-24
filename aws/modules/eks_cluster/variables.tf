
variable "flag_use_existing_vpc" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
  type        = string
  sensitive   = true
  default     = null
}

variable "dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  type        = bool
  sensitive   = true
  default     = true
}

variable "dns_hostnames" {
  description = "Indicates whether Network Address Usage metrics are enabled for your VPC."
  type        = bool
  sensitive   = true
  default     = true
}

variable "existing_vpc_id" {
  description = "The ARN of an existing IAM role to use for the Lambda function."
  type        = string
  default     = null
}

variable "flag_use_existing_internet_gateway" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "existing_internet_gateway_id" {
  description = "The ARN of an existing IAM role to use for the Lambda function."
  type        = string
  default     = null
}

variable "flag_use_existing_subnet" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "private_subnet_cidr_blocks" {
  description = "The IPv4 CIDR block for the subnet."
  type        = list(string)
  sensitive   = true
  default     = null
}

variable "private_subnet_count" {
  description = "Number of policies to attach to the IAM role"
  type        = number
  #default     = null
}

variable "private_subnet_az" {
  description = "Availability zone for subnet"
  type        = list(string)
  sensitive   = true
  default     = ["us-east-1a"]
}

variable "public_subnet_cidr_blocks" {
  description = "The IPv4 CIDR block for the subnet."
  type        = list(string)
  sensitive   = true
  default     = null
}

variable "public_subnet_count" {
  description = "Number of policies to attach to the IAM role"
  type        = number
#  default     = null
}

variable "public_subnet_az" {
  description = "Availability zone for subnet"
  type        = list(string)
  sensitive   = true
  default     = ["us-east-1a"]
}

variable "existing_private_subnet_ids" {
  description = "The ARN of an existing IAM role to use for the Lambda function."
  type        = list(string)
  default     = null
}

variable "existing_public_subnet_ids" {
  description = "The ARN of an existing IAM role to use for the Lambda function."
  type        = list(string)
  default     = null
}

variable "flag_use_existing_eip" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "existing_eip_id" {
  description = "The ARN of an existing IAM role to use for the Lambda function."
  type        = string
  default     = null
}

variable "flag_use_existing_nat_gateway" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "public_subnet_index_nat_gateway" {
  description = "Number of policies to attach to the IAM role"
  type        = number
  default     = null
}

variable "existing_nat_gateway_id" {
  description = "Number of policies to attach to the IAM role"
  type        = string
  default     = null
}

variable "flag_use_existing_private_subnet_route_table" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "route_table_private_subnet_cidr" {
  description = "The CIDR block of the route (Destination Argument)."
  type        = string
  sensitive   = true
  default     = null
}

variable "existing_private_subnet_route_table_id" {
  description = "Number of policies to attach to the IAM role"
  type        = string
  default     = null
}

variable "flag_use_existing_public_subnet_route_table" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "route_table_public_subnet_cidr" {
  description = "The CIDR block of the route (Destination Argument)."
  type        = string
  sensitive   = true
  default     = null
}

variable "existing_public_subnet_route_table_id" {
  description = "Number of policies to attach to the IAM role"
  type        = string
  default     = null
}

variable "flag_use_existing_eks_execution_role" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "eks_execution_role_policy_count" {
  description = "Number of policies to attach to the IAM role"
  type        = number
#  default     = null
}

variable "existing_eks_execution_role_iam_policy_arns" {
  description = "The ARN of an existing IAM policy to be attached to the Lambda execution role."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
}

variable "existing_eks_iam_role_arn" {
  description = "The ARN of an existing IAM policy to be attached to the Lambda execution role."
  type        = string
  default     = null
}

variable "flag_use_existing_node_group_role" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false

}

variable "node_group_policy_count" {
  description = "Number of policies to attach to the IAM role"
  type        = number
  #default     = null
}

variable "existing_node_group_iam_policy_arns" {
  description = "The ARN of an existing IAM policy to be attached to the Lambda execution role."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}

variable "existing_node_group_iam_role_arn" {
  description = "The ARN of an existing IAM policy to be attached to the Lambda execution role."
  type        = string
  default     = null
}

#variable "private_subnet1_cidr" {
#  description = "The IPv4 CIDR block for the subnet."
#  type        = string
#  sensitive   = true
#}
#
#variable "private_subnet2_cidr" {
#  description = "The IPv4 CIDR block for the subnet."
#  type        = string
#  sensitive   = true
#}
#
#variable "public_subnet1_cidr" {
#  description = "The IPv4 CIDR block for the subnet."
#  type        = string
#  sensitive   = true
#}
#
#variable "public_subnet2_cidr" {
#  description = "The IPv4 CIDR block for the subnet."
#  type        = string
#  sensitive   = true
#}

#variable "subnet_az1" {
#  description = "Availability zone for subnet"
#  type        = string
#  sensitive   = true
#  default     = "us-east-1a"
#}
#
#variable "subnet_az2" {
#  description = "Availability zone for subnet"
#  type        = string
#  sensitive   = true
#  default     = "us-east-1b"
#}

variable "resource_prefix" {
  description = "Prefix to be added to the resource name"
  default     = "iot-"
}

variable "eks_role_name" {
  description = "Name for the EKS Role."
  type        = string
  default     = null
}

variable "eks_cluster_name" {
  description = "Name for the EKS Cluster."
  type        = string
}

variable "eks_node_role_name" {
  description = "Name for the EKS Node Group Role."
  type        = string
  default     = null
}

variable "eks_node_group_name" {
  description = "Name for the EKS Node Group."
  type        = string
  default     = null
}

variable "eks_node_capacity_type" {
  description = "Name for the EKS Node Group."
  type        = string
}

variable "eks_node_desired_size" {
  description = "Name for the EKS Node Group."
  type        = number
}

variable "eks_node_max_size" {
  description = "Name for the EKS Node Group."
  type        = number
}

variable "eks_node_instance_types" {
  description = "Name for the EKS Node Group."
  type        = list(string)
}

variable "eks_node_min_size" {
  description = "Name for the EKS Node Group."
  type        = number
}

variable "eks_node_max_unavailable" {
  description = "Name for the EKS Node Group."
  type        = number
}

#variable "eks_nodegroup_resource_groups" {
#  type = map(
#    number({
#      desired_size = number
#      max_size = number
#      min_size = number
#      max_unavailable = number
#    })
#  )
#  sensitive = true
#}


#variable "availability_zones_count" {
#  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
#  type        = list(string)
#  sensitive   = true
#  default     = null
#}
#
#variable "subnet_cidr_bits" {
#  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
#  type        = list(string)
#  sensitive   = true
#  default     = null
#}
#
#variable "aws_availability_zones" {
#  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
#  type        = list(string)
#  sensitive   = true
#  default     = null
#}

#variable "map_public_ip_on_launch_public" {
#  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
#  type        = list(bool)
#  sensitive   = true
#  default     = true
#}
#
#variable "map_public_ip_on_launch_private" {
#  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
#  type        = list(bool)
#  sensitive   = true
#  default     = false
#}

