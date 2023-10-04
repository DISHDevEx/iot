terraform {
  backend "s3" {
    profile        = var.profile
    region         = var.region
    bucket         = var.bucket_name
    key            = var.bucket_key
    encrypt        = true
    dynamodb_table = var.dynamodb_table_name
  }
}
