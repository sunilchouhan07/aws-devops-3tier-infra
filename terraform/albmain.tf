module "alb" {
  source              = "./modules/app_lb"
  env                 = local.env
  health_interval     = 30
  timeout             = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
  vpc_id              = module.vpc.vpc_id
  public_sub_id       = module.vpc.public_subnet_ids
}