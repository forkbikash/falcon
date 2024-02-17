variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance."
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance."
}

variable "key_name" {
  description = "The key name to use for the EC2 instance."
}

# variable "subnet_id" {
#   description = "The ID of the subnet to launch the EC2 instance in."
# }

variable "name" {
  description = "The name to use for the EC2 instance."
}

variable "security_group_ids" {
  description = "The security group ids to use for the EC2 instance."
}

variable "user_data" {
  description = "The user script to use for the EC2 instance."
}
