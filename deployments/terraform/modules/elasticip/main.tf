resource "aws_eip" "eip" {
  vpc = var.is_for_vpc
}
