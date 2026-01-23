resource "aws_db_subnet_group" "db_subnets" {
  name       = "${var.name_prefix}-db-subnets"
  subnet_ids = var.subnet_ids["db"]
}

resource "aws_db_instance" "rds_main" {
  identifier         = "${var.name_prefix}-rds-main"
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  storage_type       = "gp2"
  username    = "blogadmin"
  manage_master_user_password = true   
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [var.db_sg_id]
  skip_final_snapshot = true
}