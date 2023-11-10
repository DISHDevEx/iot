# IOT
## Introduction
This repository contains reusable Terraform modules that can be implemented with Terragrunt to manage all the cloud infrastructure internal and external lighthouses.
## Prerequisites
Inorder to use the Terraform modules with Terragrunt, you need to configure your system with following prerequisites.
1. Install Terraform
2. Install Terragrunt
3. Create your 'terragrunt.hcl' file with required provider, backend, modules and inputs.
## Execution
To deploy the resources in cloud environment as per the configuration in 'terragrunt.hcl' file, use the following Terragrunt CLI commands:
1. terragrunt init
2. terragrunt plan
3. terragrunt apply
4. terragrunt output
## Destruction
To destroy the resources in cloud environment, use the following Terragrunt CLI command:
1. terragrunt destroy
# Terragrunt Template
## Introduction
We have developed a 'Terragrunt Template' to create different types of AWS resources with desired configuration.

If you are interested to create the AWS resources using this template then please refer the instructions in this file - [README.md](https://github.com/DISHDevEx/iot/blob/main/aws/terragrunt_template/README.md)
