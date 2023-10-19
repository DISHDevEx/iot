# Terragrunt Template
## Introduction
This template can be used to create different types of AWS resources with desired configuration.
## Prerequisites
Inorder to use the Terraform modules with Terragrunt, you need to configure your system with following prerequisites.
1. Install Terraform.
2. Install Terragrunt.
3. Copy all files from this [folder](https://github.com/DISHDevEx/iot/tree/main/aws/terragrunt_template) to your local directory as per following directory structure,
```
terragrunt_template/
├── data-sources.tf
├── .gitignore
├── main.tf
├── outputs.tf
├── README.md
├── terragrunt.hcl
└── variables.tf
```
4. Create a 'provider.tfvars' file in the same directory with following data - This helps the Terragrunt to pickup the provider variable values directly from this file.

   aws_region         = "xxxxxx"

   profile            = "xxxxxx" #Profile name as defined in '~/.aws/credentials' file

   #Below vault inputs are required only if you want to pass the input values from the HashiCorp Vault

   vault_address      = "xxxxxx" 

   vault_token        = "xxxxxx"

   vault_secrets_path = "xxxxxx"

Note: 

Please DONT commit this 'provider.tfvars' file into any repository or in any publicly accessible location.

If you are interested in using HashiCorp Vault for secrets management, then please ensure to have a running HashiCorp Vault system with valid 'address', authentication 'token' and 'secrets path' with required secrets.

Please ensure to create the secrets as per the respective data type defined in the respective module - 'variables.tf' file.

5. Create a 's3_backend.tfvars.json' file in the same directory with following data - This helps the Terragrunt to pickup the backend variable values directly from this file.

   {
     "_comment_1": "Below values are used to set the configuration for S3 backend defined in 'terragrunt.hcl' file",
     "aws_region": "xxxxxxxx",
     "profile": "xxxxxxxxxxxx",
     "backend_bucket_name": "xxxxxxxxxxxxx",
     "backend_bucket_key": "xxxxxxxxxxx",
     "backend_dynamodb_table_name": "xxxxxxxxxxxx"
   }

   To pass these variables values from the json file to Terragrunt, please execute below command.
   
   #CLI command:
   Linux and mac OS CLI: export TG_VAR_FILE=s3_backend.tfvars.json
   Windows CMD: SET TG_VAR_FILE=s3_backend.tfvars.json

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