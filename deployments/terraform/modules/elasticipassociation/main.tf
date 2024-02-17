resource "aws_eip_association" "eip-association" {
  instance_id   = var.ec2_instance_id
  allocation_id = var.eip_id
}
