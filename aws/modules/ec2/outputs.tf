#Outputs
output "instance_id_and_name" {
  description = "ID of the EC2 instance"
  value = {
    id   = aws_instance.ec2[*].id,
    name = aws_instance.ec2[*].tags.Name
  }
}