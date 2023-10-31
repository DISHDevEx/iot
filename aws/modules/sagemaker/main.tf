
resource "aws_sagemaker_notebook_instance" "sagemaker_notebook_instance" {
  count = var.enable_sagemaker_notebook_instance ? 1 : 0

  name          = var.sagemaker_notebook_instance_name
  role_arn      = var.sagemaker_notebook_instance_role_arn
  instance_type = var.sagemaker_notebook_instance_instance_type

  subnet_id              = var.sagemaker_notebook_instance_subnet_id
  security_groups        = var.sagemaker_notebook_instance_security_groups
  kms_key_id             = var.sagemaker_notebook_instance_kms_key_id
  lifecycle_config_name   = var.sagemaker_notebook_instance_lifecycle_config_name
  direct_internet_access = var.sagemaker_notebook_instance_direct_internet_access
  volume_size            = var.sagemaker_notebook_volume-size

  tags = var.tags
  

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  
}