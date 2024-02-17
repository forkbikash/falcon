variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks for the subnets in the VPC"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VPC resources"
  default = {
    Environment = "dev"
    Project     = "project"
  }
}
