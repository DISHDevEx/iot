# sagemaker - module output
output "sagemaker_outputs" {
  description = "Sagemaker notebook instance name"
  value       = "Sagemaker notebook instance name = " + aws_sagemaker_notebook_instance.sagemaker_notebook_instance[*].name
}