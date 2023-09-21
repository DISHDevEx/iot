# include "root" {
#   path = find_in_parent_folders()
# }

terraform {
  source = "../../modules/ec2"
}

inputs = {
  instance_count = 1
  instance_names = ["test"]
  ami_id = "ami-03a6eaae9938c858c"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-09a1402fa96b39c67"]
  subnet_id = "subnet-06b2b3448e17d393b"
}
