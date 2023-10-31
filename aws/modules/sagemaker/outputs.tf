# sagemaker - module output
output "sagemaker_outputs" {
  description = "Sagemaker notebook instance name"
  value       = aws_sagemaker_notebook_instance.sagemaker_notebook_instance[*].name
}