resource "aws_db_instance" "java_db_instance" {
  identifier              = "java-db-${var.environment}"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  storage_type            = "gp2"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.java_db_subnet_group.name
  backup_retention_period = 7
  multi_az = false
  delete_automated_backups = false
  publicly_accessible     = true
  skip_final_snapshot     = true
  parameter_group_name    = "default.mysql8.0"
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  
  tags = {
    Name = "java-db-${var.environment}"
  }
  
}
resource "aws_security_group" "db_sg" {
  name        = "java-db-sg-${var.environment}"
  description = "Security group for Java RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "java-db-sg-${var.environment}"
  }
}
resource "aws_db_subnet_group" "java_db_subnet_group" {
  name       = "java-db-subnet-group-${var.environment}"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "java-db-subnet-group-${var.environment}"
  }
}
resource "aws_ssm_parameter" "rds_endpoint" {
  name        = "/java/${var.environment}/rds_endpoint"
  description = "RDS endpoint for Java application"
  type        = "String"
  value =  aws_db_instance.java_db_instance.endpoint
  
    }