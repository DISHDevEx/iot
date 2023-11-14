resource "aws_cloud9_environment_ec2" "this" {
  name = format("iot-%s", var.name)
  instance_type = var.instance_type
  automatic_stop_time_minutes = var.automatic_stop_time_minutes
  connection_type = var.connection_type
  description = var.description
  image_id = var.image_id
  owner_arn = var.owner_arn
  subnet_id = var.subnet_id

  tags = var.tags
}

data "aws_instance" "this" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
      aws_cloud9_environment_ec2.this.id]
  }
}

resource "aws_cloud9_environment_membership" "this" {
  count = var.create_membership ? 1 : 0

  environment_id = aws_cloud9_environment_ec2.this.id
  permissions    = var.permissions
  user_arn       = var.user_arn
}
