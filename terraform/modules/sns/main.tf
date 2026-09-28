resource "aws_sns_topic" "cloudwatch_alerts" {
  name = "${var.project}-${var.env}-cloudwatch-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.cloudwatch_alerts.arn
  protocol  = "email"
  endpoint  = var.email
}

