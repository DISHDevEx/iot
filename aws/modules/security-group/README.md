# **AWS Security Group Module**

### **Introduction:**

This module helps create AWS security groups through terraform module.

### **Pre-requisites:**

Inorder to use the Terraform modules with Terragrunt, you need to configure your system with following prerequisites.

1. Install Terraform
2. Install Terragrunt
3. Create your 'terragrunt.hcl' file with required provider, modules and inputs.

### **Input:**

The user needs to pass few parameters to customize the Security group as per requirement.
1. AWS region where the security group needs to be deployed
2. Name & Description for the Security Group
3. Ingress port, protocol, CIDR blocks to control the inbound traffic to the EC2 instance
4. Egress port, protocol, CIDR blocks to control the outbound traffic from the EC2 instance

Note: It is not mandatory to pass all the parameters. 
If any parameter value is not passed by the developer, default parameter value is applied.

### **Example:**

module "security-group" {
   source                               = "git@github.com:DISHDevEx/iot.git//aws/modules/security-group""
   security_group_name                  = "Enter security group name"
   security_group_description           = "Enter description for the security group"
   ingress_port                         = xxxx
   ingress_cidr_blocks                  = ["xxxxxxxxx"]
   ingress_source_security_group_id     = ["xxxxxxxxx"]
   egress_port                          = xxxx
   egress_protocol                      = "xxxx"
   egress_cidr_blocks                   = ["xxxxxxxxx"]
   egress_destination_security_group_id = ["xxxxxxxxx"]
}