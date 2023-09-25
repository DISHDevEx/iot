# iot
Repository for infrastructure scripts

## Initial file structure
iot
├── dev                     # Development environment
│   ├── terragrunt.hcl      # Global terragrunt.hcl
│   ├── config.hcl          # Global configurations including values for all modules
│   ├── variables.tf        # Global variables.tf
│   ├── variables.tfvars    # Global variables.tfvars
│   ├── ec2                 # Example instance
│   │    └── terragrunt.hcl # Instance terragrunt.hcl 
│   ├── s3                  # Example instance 
│   │    └── terragrunt.hcl # Instance terragrunt.hcl  
│   └── ...                 # More instances
├── prod                    # Production environment
│   ├── terragrunt.hcl      # Global terragrunt.hcl
│   ├── config.hcl          # Global configurations including values for all modules
│   ├── variables.tf        # Global variables.tf
│   ├── variables.tfvars    # Global variables.tfvars
│   ├── ec2                 # Example instance
│   │    └── terragrunt.hcl # Instance terragrunt.hcl 
│   ├── s3                  # Example instance 
│   │    └── terragrunt.hcl # Instance terragrunt.hcl  
│   └── ...                 # More instances
├── modules                 # Modules
|   ├── ec2                 # Example module
│   │    └── main.tf 
│   │    └── outputs.tf 
│   │    └── variables.tf 
|   ├── s3                  # Example module
│   │    └── main.tf 
│   │    └── outputs.tf 
│   │    └── variables.tf 
└── └── ...                 # More modules