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
