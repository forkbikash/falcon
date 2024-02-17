# creating ssh-key.
resource "aws_key_pair" "ssh-key-tf" {
  key_name   = var.key_name
  public_key = var.public_key
}
