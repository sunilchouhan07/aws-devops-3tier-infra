output "db_instance_id" {
  value = aws_db_instance.main.id
}


output "db_host" {
  value = aws_db_instance.main.address
}

output "db_port" {
  value = aws_db_instance.main.port
}

output "db_secret_arn" {
  value = aws_db_instance.main.master_user_secret[0].secret_arn
}
