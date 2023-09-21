#Outputs
output "instance-id-and-public-ip" {
  value = zipmap(aws_instance.ec2[*].id, aws_instance.ec2[*].public_ip)
}