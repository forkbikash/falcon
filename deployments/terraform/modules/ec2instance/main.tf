resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  # subnet_id     = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = var.name
  }

  user_data = var.user_data
}
