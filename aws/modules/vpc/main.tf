# Create a VPC
resource "aws_vpc" "iot_vpc" {
  # count = length(var.vpc_name)
  cidr_block          = var.vpc_cidr_block
  instance_tenancy    = var.vpc_instance_tenancy
  enable_dns_support  = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.vpc_assign_generated_ipv6_cidr_block
  
  tags = {
    Name = format("iot_%s", var.vpc_name)
  }
}

# Create a subnet
resource "aws_subnet" "iot_subnet" {
  count = length(var.subnet_name)
  vpc_id                  = aws_vpc.iot_vpc.id
  cidr_block              = var.subnet_cidr_block[count.index]
  availability_zone       = var.subnet_availability_zone[count.index]
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch
  assign_ipv6_address_on_creation = var.subnet_assign_ipv6_address_on_creation

  tags = {
    Name = format("iot_%s", var.subnet_name[count.index])
  }
}

# Create a default route table
resource "aws_route_table" "iot_route_table" {
  vpc_id = aws_vpc.iot_vpc.id
  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = 	var.route_table_gateway_id
  }
  tags = {
    Name = format("iot_%s", var.route_table_name)
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "my_subnet_association" {
  count          = length(var.subnet_name)
  subnet_id      = aws_subnet.iot_subnet[count.index].id
  route_table_id = aws_route_table.iot_route_table.id
}

