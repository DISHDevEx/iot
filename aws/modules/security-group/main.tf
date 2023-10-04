#Create AWS Security Group
resource "aws_security_group" "iot_security_group_template" {
  name        = "${var.security_group_prefix}${var.security_group_name}"
  description = var.security_group_description

  ingress {
    from_port                = var.ingress_port
    to_port                  = var.ingress_port
    protocol                 = var.ingress_protocol
    cidr_blocks              = var.ingress_cidr_blocks
    security_groups          = var.ingress_source_security_group_id
  }

  egress {
    from_port                     = var.egress_port
    to_port                       = var.egress_port
    protocol                      = var.egress_protocol
    cidr_blocks                   = var.egress_cidr_blocks
    security_groups               = var.egress_destination_security_group_id
  }

  tags = {
    Name = var.security_group_name
  }
}


































#module "vote_service_sg" {
#  source = "terraform-aws-modules/security-group/aws"
#
#  name        = "user-service"
#  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
#  vpc_id      = "vpc-12345678"
#
#  ingress_cidr_blocks      = ["10.10.0.0/16"]
#  ingress_rules            = ["https-443-tcp"]
#  ingress_with_cidr_blocks = [
#    {
#      from_port   = 8080
#      to_port     = 8090
#      protocol    = "tcp"
#      description = "User-service ports"
#      cidr_blocks = "10.10.0.0/16"
#    },
#    {
#      rule        = "postgresql-tcp"
#      cidr_blocks = "0.0.0.0/0"
#    },
#  ]
#}