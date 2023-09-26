# **AWS Lambda Module** 

### **Introduction:**

This module creates a Lambda function with python3.8 as the default runtime in AWS.

### **Pre-requisites:**

Inorder to use the Terraform modules with Terragrunt, you need to configure your system with following prerequisites.

1. Install Terraform
2. Install Terragrunt
3. Create your 'terragrunt.hcl' file with required provider, modules and inputs.

### **Input:**

The user needs to pass few parameters to customize the Lambda function as per requirement.
1. Function_name
2. Path to the Lambda function deployment package
3. ARN of the IAM role for the Lambda function
4. Lambda function handler
5. Lambda function Runtime


Note: If the file is not in the current working directory you will need to include a
path.module in the filename.