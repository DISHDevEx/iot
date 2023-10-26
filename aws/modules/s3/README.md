
### S3 Module Inputs - With HashiCorp Vault:
#Example for 's3' module
1. bucket_name = data.vault_generic_secret.getsecrets.data["bucket_name"]
2. bucket_versioning = data.vault_generic_secret.getsecrets.data["bucket_versioning"]
# If you want to pass any custom bucket policy - json file, then include below variables as well.
3. pass_bucket_policy_file = data.vault_generic_secret.getsecrets.data["pass_bucket_policy_file"]
4. bucket_policy_file_path = data.vault_generic_secret.getsecrets.data["bucket_policy_file_path"]
# If you want to create more than one S3 bucket with policy file, then ensure to pass respective bucket-policy files using 'bucket_policy_file_path' variable.

**Note:** Here the variable vaules of bucket_name, bucket_versioning, pass_bucket_policy_file, bucket_policy_file_path  will be passed directly from HashiCorp Vault.

### S3 Module Inputs - Without HashiCorp Vault:
#Example for 's3' module
1. bucket_name = "xxxxxxxxx"
2. bucket_versioning = "xxxxxxx"
# If you want to pass any custom bucket policy - json file, then include below variables as well.
3. pass_bucket_policy_file = true
4. bucket_policy_file_path = "xxxxxxx"
# If you want to create more than one S3 bucket with policy file, then ensure to pass respective bucket-policy files using 'bucket_policy_file_path' variable.