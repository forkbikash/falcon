# AWS region where the infrastructure will be created
variable "aws_region" {
  type = string
  # default = "us-east-2"
}

# # VPC CIDR block
# variable "vpc_cidr_block" {
#   type = string
#   # default = "10.0.0.0/16"
# }

# # Subnet CIDR blocks
# variable "public_subnet_cidrs" {
#   type = list(string)
#   # default = ["10.0.1.0/24", "10.0.2.0/24"]
# }

# variable "private_subnet_cidrs" {
#   type = list(string)
#   # default = ["10.0.3.0/24", "10.0.4.0/24"]
# }

# EC2 instance variables
variable "ec2_ami_id" {
  type = string
  # default = "ami-0c55b159cbfafe1f0"
}

variable "ec2_instance_type" {
  type = string
  # default = "t2.micro"
}

# aws key pair variables
variable "key_name" {
  type = string
  # default = "ssh-key-tf"
}

variable "ec2_security_group_ingress_rules" {
  description = "A list of ingress rules for the ec2 security group."
  type = list(object({
    description      = string
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  # default = []
}
variable "ec2_security_group_egress_rules" {
  description = "A list of egress rules for the ec2 security group."
  type = list(object({
    description      = string
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  # default = []
}

# variable "rds_security_group_ingress_rules" {
#   description = "A list of ingress rules for the rds security group."
#   type = list(object({
#     description      = string
#     protocol         = string
#     from_port        = number
#     to_port          = number
#     cidr_blocks      = list(string)
#     ipv6_cidr_blocks = list(string)
#     security_groups  = list(string)
#   }))
#   # default = []
# }
variable "rds_security_group_egress_rules" {
  description = "A list of egress rules for the rds security group."
  type = list(object({
    description      = string
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  # default = []
}

variable "ec2_instance_name" {
  type = string
  # default = file("${path.module}/id_rsa.pub")
}

variable "ec2_sg_description" {
  type = string
}
variable "ec2_sg_name" {
  type = string
}

variable "rds_sg_description" {
  type = string
}
variable "rds_sg_name" {
  type = string
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "aws_version" {
  type = string
}

variable "iam_user_ses" {
  type = string
}
variable "iam_group_ses" {
  type = string
}
variable "iam_policy_arn_ses_full_access" {
  type = string
}

variable "iam_user_s3" {
  type = string
}
variable "iam_group_s3" {
  type = string
}
variable "iam_policy_arn_s3_full_access" {
  type = string
}

variable "rds_instance_identifier" {
  type = string
}
variable "rds_engine" {
  type = string
}
variable "rds_engine_version" {
  type = string
}
variable "rds_instance_class" {
  type = string
}
variable "rds_username" {
  type      = string
  sensitive = true
}
variable "rds_password" {
  type      = string
  sensitive = true
}
variable "rds_storage_type" {
  type = string
}
variable "rds_name" {
  type = string
}
variable "rds_allocated_storage" {
  type = number
}
variable "rds_backup_retention_period" {
  type = number
}

variable "is_for_vpc" {
  type = bool
}

variable "bucket" {
  type = string
}
variable "s3_bucket_ownership_controls_rule_object_ownership" {
  type = string
}
variable "block_public_acls" {
  type = bool
}
variable "block_public_policy" {
  type = bool
}
variable "ignore_public_acls" {
  type = bool
}
variable "restrict_public_buckets" {
  type = bool
}
variable "s3_bucket_acl" {
  type = string
}

# not used
variable "s3_referer" {
  type = string
}
