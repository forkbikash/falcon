resource "aws_subnet" "subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags              = merge(local.default_tags, var.tags)

  map_public_ip_on_launch = true
}
