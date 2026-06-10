module "monitoring" {
  source = "./modules/monitoring"

  env                 = local.env
  asg_name            = module.ec2_asg.asg_name
  target_group_suffix = module.alb.target_group_suffix
  lb_suffix           = module.alb.lb_suffix
  db_instance_id      = module.rds.db_instance_id
}