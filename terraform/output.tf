output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_sub_app_ids" {
  value = module.vpc.private_sub_app_ids
}

output "private_sub_rds_ids" {
  value = module.vpc.private_sub_rds_ids
}


output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_sg_id" {
  value = module.alb.alb_sg_id
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "endpoint" {
  value = module.rds.endpoint
}
