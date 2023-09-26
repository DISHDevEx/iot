#Outputs
output "instance-id-and-public-ip" {
  value = zipmap(aws_instance.ec2[*].id, aws_instance.ec2[*].public_ip)
}
output "instance-id-and-private-ip" {
  value = zipmap(aws_instance.ec2[*].id, aws_instance.ec2[*].private_ip)
}