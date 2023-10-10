# Terragrunt Template
## Introduction
This template can be used to create different types of AWS resources with desired configuration.
## Prerequisites
Inorder to use the Terraform modules with Terragrunt, you need to configure your system with following prerequisites.
1. Install Terraform.
2. Install Terragrunt.
3. Copy all files from this [folder](https://github.com/DISHDevEx/iot/tree/main/aws/terragrunt_template) to your local directory as per following directory structure,
```
terragrunt_template
    ├── data-sources.tf
    ├── main.tf
    ├── outputs.tf
    ├── set-env-vars.sh
    ├── terragrunt.hcl
    └── variables.tf
```
4. Create a 'terraform.tfvars' file in the same directory with following inputs - This helps the Terragrunt to pickup the input values directly from the 'terraform.tfvars' file

   aws_region         = "xxxxxx"

   profile            = "xxxxxx" #Profile name as defined in '~/.aws/credentials' file

   #Below vault inputs are required only if you want to pass the input values from the HashiCorp Vault

   vault_address      = "xxxxxx" 

   vault_token        = "xxxxxx"

   vault_secrets_path = "xxxxxx"

Note: 
Please DONT commit this 'terraform.tfvars' file into any repository or in any publicly accessible location.
If you are interested in using HashiCorp Vault for secrets management, then please ensure to have a running HashiCorp Vault system with valid 'address', authentication 'token' and 'secrets path' with required secrets - iam_role, key_pair_name, subnet_id, vpc_security_group_ids.

Please ensure to create the secrets as per the respective data type defined in 'variables.tf' file.

5. Set environment variables required for S3 backend initialization in Terragrunt. To set these environment variables, you can run the following command in a linux CLI.
   
   #Command: source ./set-env-vars.sh 

## Module Inputs
If you are interested in using HashiCorp Vault for secrets management, then please follow below steps:
1. Uncomment the vault datasource defined in 'data-sources.tf' file
2. Uncomment the vault provider defined in 'terragrunt.hcl' file
3. Update the outputs as required in 'outputs.tf' file
4. Update the 'main.tf' file with required modules and respective inputs

If you are NOT interested in using HashiCorp Vault for secrets management, then please follow below steps:
1. Update the modules as required in 'main.tf' file
2. Update the outputs as required in 'outputs.tf' file
3. Update the 'main.tf' file with required modules and respective inputs

## Execution
To deploy the resources in cloud environment as per the configuration in 'terragrunt.hcl' file, use the following Terragrunt CLI commands:
1. terragrunt plan
2. terragrunt apply
3. terragrunt output
## Destruction
To destroy the resources in cloud environment, use the following Terragrunt CLI commands:
1. terragrunt destroy