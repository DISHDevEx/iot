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

/*
### Module Inputs - With HashiCorp Vault:
#Example for 'ec2' module
1. instance_count          = 2
2. ami_id                  = "ami-0a89b4f85b0b6f49c"
3. instance_type           = "t2.micro"
4. root_volume_type        = "gp3"
5. root_volume_size        = 20
6. root_volume_encrypted   = true
7. root_volume_termination = true
8. instance_names          = ["Dev1_Env","Dev2_Env"]
9. iam_role                = data.vault_generic_secret.getsecrets.data["iam_role"]
10. key_pair_name          = data.vault_generic_secret.getsecrets.data["key_pair_name"]
11. subnet_id              = data.vault_generic_secret.getsecrets.data["subnet_id"]
12. vpc_security_group_ids = [data.vault_generic_secret.getsecrets.data["vpc_security_group_ids"]]

**Note:** Here the variable vaules of iam_role, key_pair_name, subnet_id, vpc_security_group_ids will be passed directly from HashiCorp Vault.

### Module Inputs - Without HashiCorp Vault:
#Example for 'ec2' module
1. instance_count          = 2
2. ami_id                  = "ami-0a89b4f85b0b6f49c"
3. instance_type           = "t2.micro"
4. root_volume_type        = "gp3"
5. root_volume_size        = 20
6. root_volume_encrypted   = true
7. root_volume_termination = true
8. instance_names          = ["Dev1_Env","Dev2_Env"]
9. iam_role                = "xxxxxxxxxx"
10. key_pair_name          = "xxxxxxxxxx"
11. subnet_id              = "xxxxxxxxxx"
12. vpc_security_group_ids = ["xxxxxxxxxx"]
*/