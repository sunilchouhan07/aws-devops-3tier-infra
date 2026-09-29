


resource "aws_cloudwatch_metric_alarm" "asg_instances_low" {
  alarm_name        = "${var.project}-${var.env}-asg-instances-low"
  alarm_description = "Alarm when the application ASG has fewer than 2 InService instances"

  namespace           = "AWS/AutoScaling"
  metric_name         = "GroupInServiceInstances"
  statistic           = "Minimum"
  period              = 60
  evaluation_periods  = 2
  threshold           = var.instance_capacity_threshold
  comparison_operator = "LessThanThreshold"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [
    var.sns_topic_arn
  ]

  treat_missing_data = "breaching"
}



resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name        = "${var.project}-${var.env}-alb-5xx"
  alarm_description = "Alarm when the ALB returns a high number of HTTP 5xx responses"

  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 2
  threshold           = var.alb_5xx_threshold
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = [
    var.sns_topic_arn
  ]

  treat_missing_data = "notBreaching"
}



resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name        = "${var.project}-${var.env}-alb-unhealthy-targets"
  alarm_description = "Alarm when the ALB has unhealthy backend targets"

  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 2
  threshold           = var.alb_threshold
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = [
    var.sns_topic_arn
  ]

  treat_missing_data = "notBreaching"
}



resource "aws_cloudwatch_metric_alarm" "alb_rejected_connections" {
  alarm_name        = "${var.project}-${var.env}-alb-rejected-connections"
  alarm_description = "Alarm when the ALB rejects a high number of connection attempts"

  namespace           = "AWS/ApplicationELB"
  metric_name         = "RejectedConnectionCount"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 2
  threshold           = var.alb_rejected_connections
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = [
    var.sns_topic_arn
  ]

  treat_missing_data = "notBreaching"
}



resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  alarm_name        = "${var.project}-${var.env}-ec2-high-cpu"
  alarm_description = "Alarm when EC2 utilization is above 80%"

  namespace           = "CWAgent"
  metric_name         = "cpu_usage_user"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = var.cpu_threshold
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [
    var.sns_topic_arn
  ]

  treat_missing_data = "notBreaching"
}



resource "aws_cloudwatch_metric_alarm" "asg_high_memory" {
  alarm_name        = "${var.project}-${var.env}-asg-high-memory"
  alarm_description = "Alarm when average memory utilization across the ASG exceeds 80%"

  namespace           = "CWAgent"
  metric_name         = "mem_used_percent"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = var.memory_threshold
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [
    var.sns_topic_arn
  ]

  treat_missing_data = "notBreaching"
}


resource "aws_cloudwatch_metric_alarm" "ec2_high_disk" {
  alarm_name        = "${var.project}-${var.env}-ec2-high-disk"
  alarm_description = "Alarm when root filesystem usage exceeds 80%"

  namespace           = "CWAgent"
  metric_name         = "disk_used_percent"
  statistic           = "Maximum"
  period              = 300
  evaluation_periods  = 2
  threshold           = var.disk_threshold
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [
    var.sns_topic_arn
  ]

  treat_missing_data = "notBreaching"
}


