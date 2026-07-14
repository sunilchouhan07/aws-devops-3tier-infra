module "alb" {
  source              = "./modules/app_lb"
  env                 = local.env
  health_interval     = 300
  timeout             = 30
  healthy_threshold   = 10
  unhealthy_threshold = 10
  vpc_id              = module.vpc.vpc_id
  public_sub_id       = module.vpc.public_subnet_ids
}