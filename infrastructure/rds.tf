# Create RDS
resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = [aws_subnet.public_subnet.id, aws_subnet.public_subnet1.id]
}

resource "aws_db_instance" "g1t3-sharedmysql" {
  identifier                = "g1t3-sharedmysql"
  allocated_storage         = 5
  backup_retention_period   = 2
  backup_window             = "01:00-01:30"
  maintenance_window        = "sun:03:00-sun:03:30"
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.t2.micro"
  username                  = "root"
  password                  = "cs302_g1t3"
  port                      = "3306"
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids    = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]
  skip_final_snapshot       = true
  final_snapshot_identifier = "g1t3-sharedmysql-db-final"
  publicly_accessible       = true
  multi_az                  = false
}
