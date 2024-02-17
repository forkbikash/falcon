# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

# output "public_subnet_ids" {
#   value = module.vpc.public_subnet_ids
# }

output "ec2_instance_public_ip" {
  value = module.ec2_instance.public_ip
}
