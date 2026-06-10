output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "target_group_suffix" {
  value = aws_lb_target_group.app_tg.arn_suffix
}

output "lb_suffix" {
  value = aws_lb.app_alb.arn_suffix
}