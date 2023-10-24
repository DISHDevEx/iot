#Assigning the local region variable
data "aws_region" "current" {
}

#Assigning the local account id
data "aws_caller_identity" "current" {
}

#Creating a VPC
resource "aws_vpc" "iot_vpc_template" {
  count                = var.flag_use_existing_vpc ? 0 : 1
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    created_using = "IOT_Terraform_module"
  }
}

#Creating Internet Gateway in VPC
resource "aws_internet_gateway" "igw_template" {
  count  = var.flag_use_existing_internet_gateway ? 0 : 1
  vpc_id = var.flag_use_existing_vpc ? var.existing_vpc_id : aws_vpc.iot_vpc_template[0].id

  tags   = {
    created_using = "IOT_Terraform_module"
  }
}

##Creating 2 private and public subnets in different availability zones
#resource "aws_subnet" "private-subnet_az1_template" {
#  vpc_id                  = aws_vpc.iot_vpc_template.id
#  cidr_block              = var.private_subnet1_cidr
#  availability_zone       = var.subnet_az1
#  map_public_ip_on_launch = var.map_public_ip_on_launch
#
#  tags = {
#    "availability_zone"  = var.subnet_az1
#    "created_using"      = "IOT_Terraform_module"
#  }
#}
#
#resource "aws_subnet" "private-subnet_az2_template" {
#  vpc_id                  = aws_vpc.iot_vpc_template.id
#  cidr_block              = var.private_subnet2_cidr
#  availability_zone       = var.subnet_az2
#  map_public_ip_on_launch = var.map_public_ip_on_launch
#
#  tags = {
#    "availability_zone"  = var.subnet_az1
#    "created_using"      = "IOT_Terraform_module"
#  }
#}
#
#resource "aws_subnet" "public-subnet_az1_template" {
#  vpc_id                  = aws_vpc.iot_vpc_template.id
#  cidr_block              = var.public_subnet1_cidr
#  availability_zone       = var.subnet_az1
#  map_public_ip_on_launch = var.map_public_ip_on_launch
#
#  tags = {
#    "availability_zone"  = var.subnet_az1
#    "created_using"      = "IOT_Terraform_module"
#  }
#}
#
#resource "aws_subnet" "public-subnet_az2_template" {
#  vpc_id                  = aws_vpc.iot_vpc_template.id
#  cidr_block              = var.public_subnet2_cidr
#  availability_zone       = var.subnet_az2
#  map_public_ip_on_launch = var.map_public_ip_on_launch
#
#  tags = {
#    "availability_zone"  = var.subnet_az1
#    "created_using"      = "IOT_Terraform_module"
#  }
#}

#Creating private subnets in different availability zones
resource "aws_subnet" "private_subnet_template" {
  count                   = var.private_subnet_count * (var.flag_use_existing_subnet ? 0 : 1)
  vpc_id                  = var.flag_use_existing_vpc ? var.existing_vpc_id : aws_vpc.iot_vpc_template[0].id
  cidr_block              = var.private_subnet_cidr_blocks[count.index]
  availability_zone       = var.private_subnet_az[count.index]
  map_public_ip_on_launch = false

  tags = {
    "availability_zone"  = var.private_subnet_az[count.index]
    "created_using"      = "IOT_Terraform_module"
  }
}

#Creating public subnets in different availability zones
resource "aws_subnet" "public_subnet_template" {
  count                   = var.public_subnet_count * (var.flag_use_existing_subnet ? 0 : 1)
  vpc_id                  = var.flag_use_existing_vpc ? var.existing_vpc_id : aws_vpc.iot_vpc_template[0].id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.public_subnet_az[count.index]
  map_public_ip_on_launch = true

  tags = {
    "availability_zone"  = var.public_subnet_az[count.index]
    "created_using"      = "IOT_Terraform_module"
  }
}

#Creating Elastic IP & NAT Gateway to provide internet through private subnets
resource "aws_eip" "nat_eip" {
  count = var.flag_use_existing_eip ? 0 : 1
  vpc = true

  tags = {
    Name            = "nat"
    "created_using" = "IOT_Terraform_module"
  }
}

resource "aws_nat_gateway" "nat_gateway_template" {
  count         = var.flag_use_existing_nat_gateway ? 0 : 1
  allocation_id = var.flag_use_existing_eip ? var.existing_eip_id : aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet_template[var.public_subnet_index_nat_gateway].id

  tags = {
#    "availability_zone"  = var.public_subnet_az
    "created_using"      = "IOT_Terraform_module"
  }

#  depends_on = [aws_internet_gateway.igw_template, aws_subnet.public_subnet_template]
}

#Creating Routing tables and associating subnets with them
resource "aws_route_table" "private_subnet" {
  count  = var.flag_use_existing_private_subnet_route_table ? 0 : 1
  vpc_id = var.flag_use_existing_vpc ? var.existing_vpc_id : aws_vpc.iot_vpc_template[0].id

  route {
      cidr_block                 = var.route_table_private_subnet_cidr
      nat_gateway_id             = var.flag_use_existing_nat_gateway ? var.existing_nat_gateway_id : aws_nat_gateway.nat_gateway_template[0].id
#      carrier_gateway_id         = ""
#      destination_prefix_list_id = ""
#      egress_only_gateway_id     = ""
#      gateway_id                 = ""
#      instance_id                = ""
#      ipv6_cidr_block            = ""
#      local_gateway_id           = ""
#      network_interface_id       = ""
#      transit_gateway_id         = ""
#      vpc_endpoint_id            = ""
#      vpc_peering_connection_id  = ""
#      core_network_arn           = ""
    }

  tags = {
    Name            = "private"
    "created_using" = "IOT_Terraform_module"
  }
}

resource "aws_route_table" "public_subnet" {
  count  = var.flag_use_existing_public_subnet_route_table ? 0 : 1
  vpc_id = var.flag_use_existing_vpc ? var.existing_vpc_id : aws_vpc.iot_vpc_template[0].id

  route {
      cidr_block                 = var.route_table_public_subnet_cidr
      gateway_id                 = var.flag_use_existing_internet_gateway ? var.existing_internet_gateway_id : aws_internet_gateway.igw_template[0].id
#      nat_gateway_id             = ""
#      carrier_gateway_id         = ""
#      destination_prefix_list_id = ""
#      egress_only_gateway_id     = ""
#      instance_id                = ""
#      ipv6_cidr_block            = ""
#      local_gateway_id           = ""
#      network_interface_id       = ""
#      transit_gateway_id         = ""
#      vpc_endpoint_id            = ""
#      vpc_peering_connection_id  = ""
#      core_network_arn           = ""
    }

  tags = {
    Name = "public"
  }
}

#resource "aws_route_table_association" "private_route_table_association_template" {
#  subnet_id      = aws_subnet.private-subnet_az1_template.id
#  route_table_id = aws_route_table.private_subnet.id
#}
#
#resource "aws_route_table_association" "private-subnet_az2_template" {
#  subnet_id      = aws_subnet.private-subnet_az2_template.id
#  route_table_id = aws_route_table.private_subnet.id
#}
#
#resource "aws_route_table_association" "public-subnet_az1_template" {
#  subnet_id      = aws_subnet.public-subnet_az1_template.id
#  route_table_id = aws_route_table.public_subnet.id
#}
#
#resource "aws_route_table_association" "public-subnet_az2_template" {
#  subnet_id      = aws_subnet.public-subnet_az2_template.id
#  route_table_id = aws_route_table.public_subnet.id
#}

resource "aws_route_table_association" "private_route_table_association_template" {
  count          = var.private_subnet_count * (var.flag_use_existing_subnet ? 0 : 1)
  subnet_id      = var.flag_use_existing_subnet ? var.existing_private_subnet_ids : aws_subnet.private_subnet_template[*].id
  route_table_id = var.flag_use_existing_private_subnet_route_table ? var.existing_private_subnet_route_table_id : aws_route_table.private_subnet[0].id

#  depends_on = [aws_subnet.private_subnet_template]
}

resource "aws_route_table_association" "public_route_table_association_template" {
  count          = var.public_subnet_count * (var.flag_use_existing_subnet ? 0 : 1)
  subnet_id      = var.flag_use_existing_subnet ? var.existing_public_subnet_ids : aws_subnet.public_subnet_template[*].id
  route_table_id = var.flag_use_existing_public_subnet_route_table ? var.existing_public_subnet_route_table_id :aws_route_table.public_subnet[0].id

#  depends_on = [aws_subnet.public_subnet_template]
}


#Creating EKS Cluster
resource "aws_iam_role" "eks_execution_role" {
  count = var.flag_use_existing_eks_execution_role ? 0 : 1
  name = "${var.resource_prefix}${var.eks_role_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#  role       = aws_iam_role.eks_execution_role.name
#}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_eks_execution_role" {
  count      = var.eks_execution_role_policy_count * (var.flag_use_existing_eks_execution_role ? 0 : 1)
  policy_arn = var.existing_eks_execution_role_iam_policy_arns[count.index]
  role       = aws_iam_role.eks_execution_role[0].name
}

resource "aws_eks_cluster" "eks_cluster_template" {
  name     = "${var.resource_prefix}${var.eks_cluster_name}"
  role_arn = var.flag_use_existing_eks_execution_role ? var.existing_eks_iam_role_arn : aws_iam_role.eks_execution_role[0].arn

  vpc_config {
    subnet_ids = var.flag_use_existing_subnet ? concat(var.existing_private_subnet_ids, var.existing_public_subnet_ids) : concat(aws_subnet.private_subnet_template[*].id, aws_subnet.public_subnet_template[*].id)
  }

  #  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]
}

#resource "aws_eks_cluster" "eks_cluster_template" {
#  name     = "${var.resource_prefix}${var.eks_cluster_name}"
#  #  var.flag_use_existing_role ? var.existing_role_arn : aws_iam_role.lambda_execution_role[0].arn
#  role_arn = var.flag_use_existing_eks_execution_role ? var.existing_eks_iam_role_arns : aws_iam_role.eks_execution_role[0].arn
#
#  vpc_config {
#    subnet_ids = [
#      aws_subnet.private-subnet_az1_template.id,
#      aws_subnet.private-subnet_az2_template.id,
#      aws_subnet.public-subnet_az1_template.id,
#      aws_subnet.public-subnet_az2_template.id
#    ]
#  }
#
#  #  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]
#}

#Creating Managed Node group
resource "aws_iam_role" "managed_node_group_role" {
  count = var.flag_use_existing_node_group_role ? 0 : 1
  name = "${var.resource_prefix}${var.eks_node_role_name}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

#Attach IAM Policy to managed_node_group_role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_node_group_role" {
  count       = var.node_group_policy_count * (var.flag_use_existing_node_group_role ? 0 : 1)
  role        = aws_iam_role.managed_node_group_role[0].name
  policy_arn  = var.existing_node_group_iam_policy_arns[count.index]
}

#resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#  role       = aws_iam_role.managed_node_group_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role       = aws_iam_role.managed_node_group_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#  role       = aws_iam_role.managed_node_group_role.name
#}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster_template.name
  node_group_name = "${var.resource_prefix}${var.eks_node_group_name}"
  node_role_arn   = var.flag_use_existing_node_group_role ? var.existing_node_group_iam_role_arn : aws_iam_role.managed_node_group_role[0].arn

  subnet_ids = var.flag_use_existing_subnet ? var.existing_private_subnet_ids : aws_subnet.private_subnet_template[*].id
  capacity_type  = var.eks_node_capacity_type
  instance_types = var.eks_node_instance_types

  scaling_config {
    desired_size = var.eks_node_desired_size
    max_size     = var.eks_node_max_size
    min_size     = var.eks_node_min_size
  }

  update_config {
    max_unavailable = var.eks_node_max_unavailable
  }

  labels = {
    role = "general"
  }

  # taint {
  #   key    = "team"
  #   value  = "devops"
  #   effect = "NO_SCHEDULE"
  # }

  # launch_template {
  #   name    = aws_launch_template.eks-with-disks.name
  #   version = aws_launch_template.eks-with-disks.latest_version
  # }

  depends_on = [
    aws_iam_role_policy_attachment.attach_iam_policy_to_node_group_role
  ]
}

#resource "aws_eks_node_group" "private-nodes" {
#  cluster_name    = aws_eks_cluster.eks_cluster_template.name
#  node_group_name = "${var.resource_prefix}${var.eks_node_group_name}"
#  node_role_arn   = aws_iam_role.managed_node_group_role.arn
#
#  subnet_ids = [
#    aws_subnet.private-subnet_az1_template.id,
#    aws_subnet.private-subnet_az2_template.id
#  ]
#
#  capacity_type  = var.eks_node_capacity_type
#  instance_types = var.eks_node_instance_types
#
#  scaling_config {
#    desired_size = var.eks_node_desired_size
#    max_size     = var.eks_node_max_size
#    min_size     = var.eks_node_min_size
#  }
#
#  update_config {
#    max_unavailable = var.eks_node_max_unavailable
#  }
#
#  labels = {
#    role = "general"
#  }
#
#  # taint {
#  #   key    = "team"
#  #   value  = "devops"
#  #   effect = "NO_SCHEDULE"
#  # }
#
#  # launch_template {
#  #   name    = aws_launch_template.eks-with-disks.name
#  #   version = aws_launch_template.eks-with-disks.latest_version
#  # }
#
#  depends_on = [
#    aws_iam_role_policy_attachment.attach_iam_policy_to_node_group_role
#  ]
#}

# resource "aws_launch_template" "eks-with-disks" {
#   name = "eks-with-disks"
#
#   key_name = "local-provisioner"
#
#   block_device_mappings {
#     device_name = "/dev/xvdb"
#
#     ebs {
#       volume_size = 50
#       volume_type = "gp2"
#     }
#   }
# }


