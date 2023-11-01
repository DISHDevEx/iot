
variable "flag_use_existing_vpc" {
  description = "Specify 'true' if you want to use an existing VPC, or 'false' to create a new one."
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
  type        = string
  sensitive   = true
  default     = null
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  sensitive   = true
  default     = null
}

variable "vpc_instance_tenancy" {
  description = "Tenancy options for instances launched into the VPC."
  type        = string
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

variable "vpc_assign_generated_ipv6_cidr_block" {
  description = "Assign a generated IPv6 CIDR block to the VPC."
  type        = bool
  default     = null
}

variable "subnet_assign_ipv6_address_on_creation" {
  description = "Assign an IPv6 address to instances launched in this subnet."
  type        = bool
  default     = null
}

variable "route_table_name" {
  description = "The name of the route table."
  type        = string
  default     = null
}

variable "route_table_gateway_id" {
  description = "The ID of the internet gateway to associate with the route table."
  type        = string
  default     = null
}

variable "flag_use_existing_eks_execution_role" {
  description = "Specify 'true' if you want to use an existing IAM role, or 'false' to create a new role."
  type        = bool
  default     = false
}

variable "existing_eks_iam_role_arn" {
  description = "The ARN of an existing EKS Execution role. (If flag_use_existing_eks_execution_role = true) "
  type        = string
  default     = null
}

variable "flag_use_existing_policy" {
  description = "Specify 'true' if you want to use an existing IAM policy, or 'false' to create a new policy."
  type        = bool
  default     = true
}

variable "eks_execution_role_policy_count" {
  description = "Number of policies to be attached to the EKS Execution role"
  type        = number
  default     = 0
}

variable "existing_eks_execution_role_iam_policy_arns" {
  description = "The ARN of an existing IAM policy to be attached to the EKS Execution role."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
}

variable "iam_policy_name"{
  description = "Name of the policy to be attached to the Lambda role"
  type        = string
  default     = null
}

variable "eks_role_permission_boundary"{
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = "arn:aws:iam::064047601590:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_DishTaasAdminDev_ea612f790bd52334"
}

variable "new_iam_policy" {
  type = string
  default = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
              "lambda:Get*",
              "lambda:List*",
              "cloudwatch:GetMetricData",
              "cloudwatch:ListMetrics"
          ],
          "Effect": "Allow",
          "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogStreams",
                "logs:GetLogEvents",
                "logs:FilterLogEvents",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:DescribeQueries",
                "logs:GetLogGroupFields",
                "logs:GetLogRecord",
                "logs:GetQueryResults"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
        }
      ]
    }
  EOT
}

variable "existing_vpc_id" {
  description = "The id of an existing VPC if you choose to use an existing VPC."
  type        = string
  default     = null
}

variable "flag_use_existing_subnet" {
  description = "Specify 'true' if you want to use an existing subnet, or 'false' to create a new one."
  type        = bool
  default     = true
}

variable "subnet_name" {
  description = "Assign a name to the VPC."
  type        = list(string)
  default     = null
}

variable "subnet_cidr_blocks" {
  description = "The IPv4 CIDR block for the private subnet."
  type        = list(string)
  sensitive   = true
  default     = null
}

variable "subnet_count" {
  description = "Number of private subnets to be attached to the EKS Cluster"
  type        = number
  default     = 0
}

variable "subnet_az" {
  description = "List of Availability zones for the private subnets. (If flag_use_existing_subnet = true, value = 1 or more) "
  type        = list(string)
  sensitive   = true
  default     = ["us-east-1a"]
}

variable "existing_subnet_ids" {
  description = "The ids of the list of existing private subnets you wish to add."
  type        = list(string)
  default     = null
}

variable "flag_use_existing_subnet_route_table" {
  description = "Specify 'true' if you want to use an existing route table, or 'false' to create a new one."
  type        = bool
  default     = true
}

variable "route_table_subnet_cidr" {
  description = "The CIDR block of the route (Destination Argument)."
  type        = string
  sensitive   = true
  default     = null
}

variable "existing_subnet_route_table_id" {
  description = "The id the existing route table to be attached to the private subnets. (If flag_use_existing_private_subnet_route_table = true)"
  type        = string
  default     = null
}

variable "flag_use_existing_node_group_role" {
  description = "Specify 'true' if you want to use an node_group_role, or 'false' to create a new one."
  type        = bool
  default     = false

}

variable "node_group_policy_count" {
  description = "Number of policies to be attached to the Node Group role"
  type        = number
  default     = 0
}

variable "flag_use_existing_node_group_iam_policy" {
  description = "Specify 'true' if you want to use an existing node_group_policy, or 'false' to create a new one."
  type        = bool
  default     = false

}

variable "existing_node_group_iam_policy_arns" {
  description = "The ARN of an existing IAM policy to be attached to the Node Group role."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}

variable "existing_node_group_iam_role_arn" {
  description = "The ARN of an existing Node Group role. (If flag_use_existing_node_group_role = true)"
  type        = string
  default     = null
}

variable "node_group_permission_boundary"{
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = "arn:aws:iam::064047601590:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_DishTaasAdminDev_ea612f790bd52334"
}

variable "resource_prefix" {
  description = "Prefix to be added to the resource name"
  default     = "iot-"
}

variable "eks_role_name" {
  description = "Name for the EKS Role. (If flag_use_existing_eks_execution_role = false)"
  type        = string
  default     = null
}

variable "eks_cluster_name" {
  description = "Name for the EKS Cluster."
  type        = string
}

variable "eks_node_role_name" {
  description = "Name for the EKS Node Group Role. (If flag_use_existing_node_group_role = false)"
  type        = string
  default     = null
}

variable "eks_node_group_name" {
  description = "Name for the EKS Node Group. "
  type        = string
}

variable "eks_node_capacity_type" {
  description = "Name for the EKS Node Group. "
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
  description = "Name for the EKS Node Group. "
  type        = number
}

variable "eks_node_max_unavailable" {
  description = "Name for the EKS Node Group."
  type        = number
}

variable "map_public_ip_on_launch_public" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  type        = bool
  sensitive   = true
  default     = true
}

