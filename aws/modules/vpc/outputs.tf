#Outputs
output "vpc_id_and_name" {
  description = "ID and Name of the VPC"
  value       = { for index in aws_vpc.iot_vpc[*] : index.id => index.tags.Name }
}

output "subnet_ids" {
  value = aws_subnet.iot_subnet[*].id
}