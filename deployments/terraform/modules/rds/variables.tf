variable "instance_identifier" {
  description = "The unique identifier for the RDS instance."
}

variable "engine" {
  description = "The name of the database engine to be used for the RDS instance."
}

variable "engine_version" {
  description = "The version number of the database engine to be used for the RDS instance."
}

variable "instance_class" {
  description = "The instance type to be used for the RDS instance."
}

variable "username" {
  description = "The username for the master user for the RDS instance."
  sensitive   = true
}

variable "password" {
  description = "The password for the master user for the RDS instance."
  sensitive   = true
}

variable "allocated_storage" {
  description = "The amount of storage to allocate for the RDS instance."
}

variable "storage_type" {
  description = "The type of storage to use for the RDS instance."
}

# variable "db_subnet_group_name" {
#   description = "The name of the database subnet group to use for the RDS instance."
# }

variable "vpc_security_group_ids" {
  description = "The IDs of the VPC security groups to associate with the RDS instance."
}

variable "name" {
  description = "The name to use for the RDS instance."
}

variable "backup_retention_period" {
  description = "The backup retention period for the RDS instance."
}
