# include "root" {
#   path = find_in_parent_folders()
# }

terraform {
  source = "../../aws/modules/ec2"
}

inputs = {
  instance_count = 1
  ami_id = ""
  instance_type = ""
}
