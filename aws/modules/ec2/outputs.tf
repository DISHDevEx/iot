#Outputs
output "instance_id_and_name" {
  description = "ID and Name of the EC2 instance"
  value       = { for index in aws_instance.ec2[*] : index.id => index.tags.Name }
}