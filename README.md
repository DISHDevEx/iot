# IOT
## Introduction
This repository contains reusable Terraform modules that can be implemented with Terragrunt to manage all the cloud infrastructure internal and external lighthouses.
## Prerequisites
Inorder to use the Terraform modules with Terragrunt, you need to configure your system with following prerequisites.
1. Install Terraform
2. Install Terragrunt
3. Create your 'terragrunt.hcl' file with required provider, modules and inputs.
## Execution
To deploy the resources in cloud environment as per the configuration in 'terragrunt.hcl' file, use the following Terragrunt CLI commands:
1. terragrunt plan
2. terragrunt apply
3. terragrunt output
## Destruction
To destroy the infrastructure in cloud environment, use the following Terragrunt CLI commands:
1. terragrunt destroy


