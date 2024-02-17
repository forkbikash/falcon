resource "aws_db_instance" "rds_instance" {
  identifier        = var.instance_identifier
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  username          = var.username
  password          = var.password
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  #   db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids  = var.vpc_security_group_ids
  backup_retention_period = var.backup_retention_period
  tags = {
    Name = var.name
  }
}
