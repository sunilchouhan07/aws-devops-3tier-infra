module "ec2_asg" {
  source              = "./modules/asg"
  alb_sg_id           = module.alb.alb_sg_id
  app_vpc_id          = module.vpc.vpc_id
  private_subnets_id  = module.vpc.private_sub_app_ids
  tg_arn              = module.alb.target_group_arn
  ami                 = data.aws_ami.ubuntu_linux.id
  instance_type       = local.instance_type
  rbd_size            = local.rbd_size
  key_name            = var.key_name
  env                 = local.env
  script              = "script.sh"
  min_size            = 1
  max_size            = 4
  desired_capacity    = 2
  health_check_period = 60

}