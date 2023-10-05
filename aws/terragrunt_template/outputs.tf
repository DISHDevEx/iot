#Outputs
#ec2_instance - module output
output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance[*]
}