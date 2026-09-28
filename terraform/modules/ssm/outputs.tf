output "db_host_arn" {
  value = aws_ssm_parameter.db_host.arn
}

output "db_port_arn" {
  value = aws_ssm_parameter.db_port.arn
}

output "db_secret_arn" {
  value = aws_ssm_parameter.db_secret_arn.arn
}

output "backend_current_version_arn" {
  value = aws_ssm_parameter.backend_current_version.arn
}

output "cloudwatch_agent_parameter_arn" {
  value = aws_ssm_parameter.cloudwatch_agent_config.arn
}

output "cloudwatch_agent_parameter_name" {
  value = aws_ssm_parameter.cloudwatch_agent_config.name
}