#Outputs
output "instance_name_and_id" {
  description = "ID of the EC2 instance"
  value = {
    name = aws_instance.ec2[*].tags.name
    id   = aws_instance.ec2[*].id
  }
}