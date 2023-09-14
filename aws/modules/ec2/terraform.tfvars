/*
#Variable values
Please ensure that count of 'instance_count' and 'instance_names' variable values are matching.
#For example, 
instance_count = 2
instance_name = ["Name for first instance","Name for second instance"]
*/
aws_region = "us-east-1"
instance_count = 1
ami           = "ami-0a89b4f85b0b6f49c"
instance_type = "t2.micro"
instance_names = ["Dev_Env"]
#Note to update below varible value with your respective Hashicorp Vault application name
hashicorp_vault_app_name = "AWS-Infra-Apps"