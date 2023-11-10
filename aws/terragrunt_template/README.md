# Terragrunt Template
## Introduction
This template can be used to create different types of AWS resources with desired configuration.
## Prerequisites
In order to use the Terraform modules with Terragrunt, you need to configure your system with following prerequisites.

1. Based on your Operating System, install Terraform by following the instructions mentioned on this [page](https://developer.hashicorp.com/terraform/install)

2. Based on your Operating System, install Terragrunt by following the instructions mentioned on this [page](https://terragrunt.gruntwork.io/docs/getting-started/install/)

3. Based on your Operating System, install AWS CLI by following the instructions mentioned on this [page](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and ensure to configure the respective account credentials by following the instructions mentioned on this [page](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).

4. As the [iot](https://github.com/DISHDevEx/iot) is a private repository in [DISHDevEx](https://github.com/DISHDevEx), ensure you have access to this and add your local system SSH key to your GitHub account by following the instructions on the below pages as per your Operation System: a) [Generate new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) b) [Add SSH key to GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) c) [Test SSH connection](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection)

5. Clone the iot repository into your local system using this git command: git clone git@github.com:DISHDevEx/iot.git

6. Create a 'terraform.tfvars' file in the 'iot/aws/terragrunt_template/' directory with following data - This helps the Terragrunt to pick up the provider and backend variable values directly from this file.

   aws_region                  = "xxxxxxxx" #AWS region name. Example: "us-east-1"

   profile                     = "xxxxxxxx" #Profile name as defined in '~/.aws/credentials' file

   backend_bucket_name         = "xxxxxxxx" #S3 bucket name to store the 'terraform.tfstate' file

   backend_bucket_key          = "xxxxxxxx" #File path to store the 'terraform.tfstate' file

   backend_dynamodb_table_name = "xxxxxxxx" #Dynamodb table name to lock the 'terraform.tfstate' file 

   #Below vault inputs are required only if you want to pass the input values from the HashiCorp Vault

   vault_address      = "xxxxxx" #HashiCorp Vault http/https address

   vault_token        = "xxxxxx" #HashiCorp Vault access token

   vault_secrets_path = "xxxxxx" #Secrets path in the HashiCorp Vault instance

Note: 

Please DONT commit this 'terraform.tfvars' file into any repository or in any publicly accessible location.

If you are interested in using HashiCorp Vault for secrets management, then please ensure to have a running HashiCorp Vault system with valid 'address', authentication 'token' and 'secrets path' with required secrets.

Please ensure to create the secrets as per the data type defined in the respective module - 'variables.tf' file.

## Module Inputs
If you are interested in using HashiCorp Vault for secrets management, then please follow below steps in the 'iot/aws/terragrunt_template/' directory:
1. Uncomment the vault datasource defined in 'data-sources.tf' file
2. Uncomment the vault provider defined in 'terragrunt.hcl' file
3. Update the outputs as required in 'outputs.tf' file
4. Update the 'main.tf' file with required modules and respective inputs

If you are NOT interested in using HashiCorp Vault for secrets management, then please follow below steps:
1. Update the modules as required in 'main.tf' file
2. Update the outputs as required in 'outputs.tf' file
3. Update the 'main.tf' file with required modules and respective inputs

## Execution
To deploy the resources in cloud environment as per the configuration in 'terragrunt.hcl' file, run the following Terragrunt CLI commands in the 'iot/aws/terragrunt_template/' directory:
1. terragrunt init
2. terragrunt plan 
3. terragrunt apply
4. terragrunt output
## Destruction
To destroy the resources in cloud environment, run the following Terragrunt CLI commandin the 'iot/aws/terragrunt_template/' directory:
1. terragrunt destroy
