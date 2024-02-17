variable "vpc_id" {
  description = "ID of the VPC where the subnet will be created"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
}

variable "subnet_name" {
  description = "Name of the subnet"
}

variable "availability_zone" {
  description = "Availability Zone where the subnet will be created"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the subnet"
  default     = {}
}
