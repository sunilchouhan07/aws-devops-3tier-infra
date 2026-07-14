output "db_instance_id" {
  value = aws_db_instance.rds_db.id
}

output "endpoint" {
  value = aws_db_instance.rds_db.address
}