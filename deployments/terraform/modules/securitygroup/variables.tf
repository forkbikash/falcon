variable "name" {
  description = "The name of the security group."
}

variable "description" {
  description = "The description of the security group."
}

# variable "vpc_id" {
#   description = "The ID of the VPC for the security group."
# }

variable "ingress_rules" {
  description = "A list of ingress rules for the security group."
  type = list(object({
    description      = string
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = optional(list(string))
  }))
}

variable "egress_rules" {
  description = "A list of egress rules for the security group."
  type = list(object({
    description      = string
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
}
