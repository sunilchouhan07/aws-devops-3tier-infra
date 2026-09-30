resource "aws_ssm_parameter" "db_host" {
  name  = "/app/${var.project}-${var.env}/db/host"
  type  = "String"
  value = var.db_host
}


resource "aws_ssm_parameter" "db_port" {
  name  = "/app/${var.project}-${var.env}/db/port"
  type  = "String"
  value = var.db_port
}


resource "aws_ssm_parameter" "db_secret_arn" {
  name  = "/app/${var.project}-${var.env}/db/secret-arn"
  type  = "String"
  value = var.db_secret_arn
}

resource "aws_ssm_parameter" "backend_current_version" {
  name  = "/app/${var.project}-${var.env}/backend/current-version"
  type  = "String"
  value = var.current_version

  tags = {
    Name        = "${var.project}-${var.env}-backend-current-version"
    Environment = var.env
    Project     = var.project
  }
}


resource "aws_ssm_parameter" "cloudwatch_agent_config" {
  name        = "/app/${var.project}-${var.env}/monitoring/cloudwatch-agent"
  description = "CloudWatch Agent configuration for ${var.project}-${var.env} EC2 instances"
  type        = "String"
  tier        = "Standard"
  value       = file("${path.module}/cloudwatch-agent-config.json")
}


resource "aws_ssm_parameter" "db_name" {
  name  = "/app/${var.project}-${var.env}/db/name"
  type  = "String"
  value = var.db_name
}

resource "aws_ssm_parameter" "cloudfront_distribution_id" {
  name  = "/app/${var.project}-${var.env}/cloudfront/distribution-id"
  type  = "String"
  value = var.cloudfront_distribution_id
}