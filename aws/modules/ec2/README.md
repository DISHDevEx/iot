# EC2 Module
## Introduction
This module can be used to create desired number EC2 instances of same - instance_type & ami_id in AWS cloud.
## Prerequisites
Inorder to use the Terraform modules with Terragrunt, you need to configure your system with following prerequisites.
1. Install Terraform
2. Install Terragrunt
3. Create your 'terragrunt.hcl' file with required provider, modules and inputs.
Note: If you are interested in using HashiCorp Vault for secrets management, then please ensure to have a running HashiCorp Vault system with valid 'address', authentication 'token' and secrets path with required secrets as defined in 'main.tf' file.
## Module inputs
If you are interested in using HashiCorp Vault for secrets management, along with other variable vaules, please ensure that HashiCorp Vault variables(address,token, secrets path) are configured in the respective '.tfvars' file. Also, ensure to include the 'data-sources.tf' file in the directory. 
If you are not interested in using HashiCorp Vault for secrets management, you can skip the 'data-sources.tf' file and use the module directly in the 'terragrunt.hcl' file with required inputs.
Please ensure that count of 'instance_count' and 'instance_names' variable values are matching.

#For example, 

instance_count = 2

instance_name = ["First instance name","Second instance name"]
### Inputs - With HashiCorp Vault:
#Example
1. aws_region         = "us-east-1"
2. instance_count     = 2
3. ami_id             = "ami-0a89b4f85b0b6f49c"
4. instance_type      = "t2.micro"
5. instance_names     = ["Dev1_Env","Dev2_Env"]
6. vault_address      = "xxxxxxxxxx"
7. vault_token        = "xxxxxxxxxx"
8. vault_secrets_path = "xxxxxxxxxx"
### Inputs - Without HashiCorp Vault:
#Example
1. aws_region             = "us-east-1"
2. instance_count         = 2
3. ami_id                 = "ami-0a89b4f85b0b6f49c"
4. instance_type          = "t2.micro"
5. instance_names         = ["Dev1_Env","Dev2_Env"]
6. aws_iam_role           = "xxxxxxxxxx"
7. key_pair_name          = "xxxxxxxxxx"
8. subnet_id              = "xxxxxxxxxx"
9. vpc_security_group_ids = ["xxxxxxxxxx"]
## Execution
To deploy the resources in cloud environment as per the configuration in 'terragrunt.hcl' file, use the following Terragrunt CLI commands:
1. terragrunt plan
2. terragrunt apply
3. terragrunt output
## Destruction
To destroy the infrastructure in cloud environment, use the following Terragrunt CLI commands:
1. terragrunt destroy