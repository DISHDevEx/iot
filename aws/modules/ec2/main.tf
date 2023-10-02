#Resources
resource "aws_instance" "ec2" {
  count                = var.instance_count
  ami                  = var.ami_id
  instance_type        = var.instance_type
  monitoring           = true
  iam_instance_profile = var.iam_role
  key_name             = var.key_pair_name
  subnet_id            = var.subnet_id
  #We can assign multiple security groups and this can be configured in 'data-sources.tf' file
  vpc_security_group_ids = var.vpc_security_group_ids
  #Root Block Device configuration
  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    encrypted             = var.root_volume_encrypted
    delete_on_termination = var.root_volume_termination
  }
  #The count.index helps to assign respective instance names as per the respective variable value in the .tfvars file
  tags = {
    Name = "iot_${var.instance_names[count.index]}"
  }
}
