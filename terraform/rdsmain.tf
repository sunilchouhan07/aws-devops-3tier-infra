module "rds" {
  source            = "./modules/rdsInstance"
  allocated_storage = local.allocated_storage
  engine            = "mysql"
  engine_version    = "8.0"
  db_name           = local.db_name
  username          = local.username
  db_password       = var.db_password
  instance_class    = local.instance_class
  env               = local.env
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_sub_rds_ids
  app_sg_id         = module.ec2_asg.app_sg_id
}