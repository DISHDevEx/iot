# EC2 Module
## Introduction
This module can be used to create desired number EC2 instances of same - instance_type & ami_id in AWS cloud.
## Prerequisites
Inorder to use the Terraform modules with Terragrunt, you need to configure your system with following prerequisites.
1. Install Terraform
2. Install Terragrunt
3. Create your 'terragrunt.hcl' file with required provider, modules and inputs
Note: If you are interested in using HashiCorp Vault for secrets management, then please ensure to have a running HashiCorp Vault system with valid 'address', authentication 'token' and secrets path with required secrets as defined in 'main.tf' file.
## Module inputs
If you are interested in using HashiCorp Vault for secrets management, then please follow below steps:
1. Include the 'data-sources.tf' file form respective module directory
2. Comment out the 'Without HashiCorp Vault block' in the 'main.tf' file
3. Define inputs in the 'terragrunt.hcl' file as shown below

If you are NOT interested in using HashiCorp Vault for secrets management, then please follow below steps:
1. Remove the 'data-sources.tf' file form respective module directory
2. Comment out the 'With HashiCorp Vault block' in the 'main.tf' file
3. Define inputs in the 'terragrunt.hcl' file as shown below

For both cases, please ensure that count of 'instance_count' and 'instance_names' variable values are matching.

#For example, 

instance_count = 2

instance_name = ["First instance name","Second instance name"]
### Inputs - With HashiCorp Vault:
#Example
1. instance_count     = 2
2. ami_id             = "ami-0a89b4f85b0b6f49c"
3. instance_type      = "t2.micro"
4. instance_names     = ["Dev1_Env","Dev2_Env"]
5. vault_address      = "xxxxxxxxxx"
6. vault_token        = "xxxxxxxxxx"
7. vault_secrets_path = "xxxxxxxxxx"
### Inputs - Without HashiCorp Vault:
#Example
1. instance_count         = 2
2. ami_id                 = "ami-0a89b4f85b0b6f49c"
3. instance_type          = "t2.micro"
4. instance_names         = ["Dev1_Env","Dev2_Env"]
5. aws_iam_role           = "xxxxxxxxxx"
6. key_pair_name          = "xxxxxxxxxx"
7. subnet_id              = "xxxxxxxxxx"
8. vpc_security_group_ids = ["xxxxxxxxxx"]
## Execution
To deploy the resources in cloud environment as per the configuration in 'terragrunt.hcl' file, use the following Terragrunt CLI commands:
1. terragrunt plan
2. terragrunt apply
3. terragrunt output
## Destruction
To destroy the infrastructure in cloud environment, use the following Terragrunt CLI commands:
1. terragrunt destroy