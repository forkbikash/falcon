output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.gateway.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat.*.id
}

output "route_table_ids" {
  value = {
    public  = aws_route_table.public.id
    private = aws_route_table.private.id
  }
}

output "security_group_id" {
  value = aws_security_group.vpc.id
}
