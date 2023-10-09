# EC2 Module
## Introduction
This module can be used to create desired number EC2 instances of same - instance_type & ami_id in AWS cloud.
## Prerequisites
Inorder to use the Terraform modules with Terragrunt, you need to configure your system with following prerequisites.
1. Install Terraform
2. Install Terragrunt
3. Copy the 'terragrunt.hcl' file as per following directory structure
```
working_directory
    ├── modules
    │   └── ec2
    ├── terraform.tfvars
    └── terragrunt.hcl
```
4. Create a 'terraform.tfvars' file in the same directory where the 'terragrunt.hcl' file is located - This helps the Terragrunt to pickup the input values directly from the 'terraform.tfvars' file

Note: If you are interested in using HashiCorp Vault for secrets management, then please ensure to have a running HashiCorp Vault system with valid 'address', authentication 'token' and secrets path with required secrets - iam_role, key_pair_name, subnet_id, vpc_security_group_ids. Please ensure to create the secrets as per the respective data type defined in 'variables.tf' file.
## Module inputs
If you are interested in using HashiCorp Vault for secrets management, then please follow below steps:
1. Include the 'data-sources.tf' file from respective module directory
2. Define inputs in the 'terraform.tfvars' file as shown below

If you are NOT interested in using HashiCorp Vault for secrets management, then please follow below steps:
1. Remove the 'data-sources.tf' file from respective module directory
2. Define inputs in the 'terraform.tfvars' file as shown below

For both cases, please ensure that count of 'instance_count' and 'instance_names' variable values are matching.

#For example, 

instance_count = 2

instance_name = ["First instance name","Second instance name"]
### Inputs - With HashiCorp Vault:
#Example
1. instance_count          = 2
2. ami_id                  = "ami-0a89b4f85b0b6f49c"
3. instance_type           = "t2.micro"
4. root_volume_type        = "gp3"
5. root_volume_size        = 20
6. root_volume_encrypted   = true
7. root_volume_termination = true
8. instance_names          = ["Dev1_Env","Dev2_Env"]
9. iam_role                = data.vault_generic_secret.getsecrets.data["iam_role"]
10.key_pair_name           = data.vault_generic_secret.getsecrets.data["key_pair_name"]
11.subnet_id               = data.vault_generic_secret.getsecrets.data["subnet_id"]
12.vpc_security_group_ids  = [data.vault_generic_secret.getsecrets.data["vpc_security_group_ids"]]

**Note:** Here the variable vaules of iam_role, key_pair_name, subnet_id, vpc_security_group_ids will be passed directly from HashiCorp Vault
### Inputs - Without HashiCorp Vault:
#Example
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
## Execution
To deploy the resources in cloud environment as per the configuration in 'terragrunt.hcl' file, use the following Terragrunt CLI commands:
1. terragrunt plan
2. terragrunt apply
3. terragrunt output
## Destruction
To destroy the resources in cloud environment, use the following Terragrunt CLI commands:
1. terragrunt destroy