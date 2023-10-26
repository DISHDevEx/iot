
### Inputs required for 'ec2' module implementation:

## 'ec2' Module Inputs - With HashiCorp Vault:
#Example for 'ec2' module - You need to configure these values in the terragrunt_template/main.tf file
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

**Note:** 

a) Here the variable vaules of iam_role, key_pair_name, subnet_id, vpc_security_group_ids will be passed directly from HashiCorp Vault.

b) Please ensure that count of 'instance_count' and 'instance_names' variable values are matching. For example, if the instance_count = 2 then mention instance_name = ["First instance name","Second instance name"]

## 'ec2' Module Inputs - Without HashiCorp Vault:
#Example for 'ec2' module - You need to configure these values in the terragrunt_template/main.tf file
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

**Note:** 

a) Please ensure that count of 'instance_count' and 'instance_names' variable values are matching. For example, if the instance_count = 2 then mention instance_name = ["First instance name","Second instance name"]