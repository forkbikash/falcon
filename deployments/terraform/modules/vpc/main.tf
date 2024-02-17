resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = var.tags

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public" {
  count = length(var.subnet_cidr_blocks)

  cidr_block = var.subnet_cidr_blocks[count.index]
  vpc_id     = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  })
}

resource "aws_subnet" "private" {
  count = length(var.subnet_cidr_blocks)

  cidr_block = var.subnet_cidr_blocks[count.index]
  vpc_id     = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public"
  })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "nat" {
  count = length(aws_subnet.private)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}

resource "aws_eip" "nat" {
  count = length(aws_subnet.private)

  vpc = true
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private"
  })
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "vpc" {
  name_prefix = var.vpc_name
  vpc_id      = aws_vpc.vpc.id
  tags        = var.tags
}
