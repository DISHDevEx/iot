#Outputs
output "vpc_id_and_name" {
  description = "ID and Name of the VPC"
  value       = { for index in aws_vpc.iot_vpc[*] : index.id => index.tags.Name }
}