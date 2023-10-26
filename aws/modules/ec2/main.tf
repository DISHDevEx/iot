/*
#Resources
#EC2 resouce configuration
Example: For 'ec2' module, please ensure that count of 'instance_count' and 'instance_names' variable values are matching.
instance_count = 2
instance_name = ["First instance name","Second instance name"]
*/
resource "aws_instance" "ec2" {
  count                = var.instance_count
  ami                  = var.ami_id
  instance_type        = var.instance_type
  monitoring           = true
  iam_instance_profile = var.iam_role
  key_name             = var.key_pair_name
  subnet_id            = var.subnet_id
  #We can assign multiple security groups to the instance by passing multiple values in the inputs like ["first secrurity group id", "second secrurity group id"]
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
    Name = format("iot_%s", var.instance_names[count.index])
  }
}
