resource "aws_db_instance" "this" {
  identifier              = var.rds.identifier
  db_name                 = var.rds.db_name
  engine                  = var.rds.engine
  engine_version          = var.rds.engine_version
  instance_class          = var.rds.instance_class
  allocated_storage       = var.rds.allocated_storage
  max_allocated_storage   = var.rds.max_allocated_storage
  storage_type            = var.rds.storage_type
  username                = var.rds.username
  password                = var.rds_password
  port                    = var.rds.port
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = var.rds.publicly_accessible
  multi_az                = var.rds.multi_az
  backup_retention_period = var.rds.backup_retention_period
  skip_final_snapshot     = var.rds.skip_final_snapshot
  storage_encrypted       = var.rds.storage_encrypted
  deletion_protection     = var.rds.deletion_protection

  apply_immediately = true
}
