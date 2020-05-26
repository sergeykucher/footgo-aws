
resource "aws_db_subnet_group" "private_db_subnet_group_result" {
  name       = "${var.db_title} private db subnet group"
  subnet_ids = var.db_subnet_ids
  tags = {
    Name = "${var.db_title} private DB subnet group"
  }
}

resource "aws_db_instance" "db_result" {
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  identifier           = var.db_identifier
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  storage_type         = var.db_storage_type
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.private_db_subnet_group_result.id
  skip_final_snapshot  = true
}
