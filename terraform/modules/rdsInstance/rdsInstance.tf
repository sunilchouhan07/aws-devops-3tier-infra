resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = var.subnet_ids
  tags = {
    Name        = "${var.env}-sub-group"
    Environment = var.env
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id
  name   = "database-sg"
  tags = {
    Name        = "${var.env}-db-sg"
    Environment = var.env
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_db_instance" "rds_db" {
  allocated_storage = var.allocated_storage
  engine            = var.engine
  engine_version    = var.engine_version

  db_name  = var.db_name
  username = var.username
  password = var.db_password

  instance_class = var.instance_class
  port           = 5432
  identifier     = "${var.env}-db"
  multi_az       = true

  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false

  tags = {
    Name        = "${var.env}-database"
    Environment = var.env
  }
}
