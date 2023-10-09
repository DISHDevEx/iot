#!/bin/bash
#This script will set the environment variables required for S3 backend initialization in Terragrunt
#
#Profile: Profile name as defined in '~/.aws/credentials' file
#To set these environment variables, you can run the following command in a linux CLI
#Command: source ./set-env-vars.sh
export TF_VAR_profile=xxxxxxxxxx
export TF_VAR_bucket_name=xxxxxxxx
export TF_VAR_bucket_key=xxxxxxxxx
export TF_VAR_dynamodb_table_name=xxxxxxxxx