output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

output "id" {
  value = aws_instance.ec2_instance.id
}
