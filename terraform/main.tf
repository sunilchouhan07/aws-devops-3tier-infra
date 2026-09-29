#1 VPC Module

module "vpc" {
  source = "./modules/vpc"

  env = local.env

  project = local.project

  vpc_cidr = "10.0.0.0/16"

  alb_sub = {
    alb_1 = {
      cidr = "10.0.1.0/24"
      az   = "${local.region}a"
    }

    alb_2 = {
      cidr = "10.0.2.0/24"
      az   = "${local.region}b"
    }
  }

  instance_sub = {
    instance_1 = {
      cidr = "10.0.3.0/24"
      az   = "${local.region}a"
    }

    instance_2 = {
      cidr = "10.0.4.0/24"
      az   = "${local.region}b"
    }
  }

  rds_sub = {
    rds_1 = {
      cidr = "10.0.5.0/24"
      az   = "${local.region}a"
    }

    rds_2 = {
      cidr = "10.0.6.0/24"
      az   = "${local.region}b"
    }
  }

  nat_subnet_name = "alb_1"
}


#2 Security Groups 

module "sg" {
  source = "./modules/security-groups"

  env     = local.env
  project = local.project
  vpc_id  = module.vpc.vpc_id
}


#3 ALB Module

module "alb" {
  source = "./modules/alb"

  env                 = local.env
  project             = local.project
  vpc_id              = module.vpc.vpc_id
  alb_sub             = module.vpc.alb_subnet_ids
  health_interval     = 30
  timeout             = 5
  alb_sg_id           = module.sg.alb_sg_id
  healthy_threshold   = 3
  unhealthy_threshold = 5
}


#4 ASG Module
module "asg" {
  source = "./modules/asg"

  env     = local.env
  project = local.project

  vpc_id                          = module.vpc.vpc_id
  subnet_id                       = module.vpc.instance_subnet_ids
  tg_arn                          = module.alb.target_group_arn
  ami_id                          = data.aws_ami.amazon_linux.id
  app_sg_id                       = module.sg.app_sg_id
  cloudwatch_agent_parameter_name = module.ssm.cloudwatch_agent_parameter_name
  instance_type                   = local.instance_type
  root_volume_size                = local.root_volume_size
  min_size                        = 2
  max_size                        = 4
  desired_capacity                = 2
  health_check_period             = 300
  ec2_role                        = module.iam_role.ec2_role_name
  depends_on                      = [module.iam_role]
  aws_region                      = local.region
  current_version_parameter_name  = module.ssm.backend_current_version_name
  artifact_bucket_name            = module.s3.artifact_bucket_name
}


#5 RDS Module

module "rds" {
  source = "./modules/rds"

  env               = local.env
  project           = local.project
  allocated_storage = local.allocated_storage
  engine            = "postgres"
  engine_version    = "17"
  db_name           = local.db_name
  username          = local.username
  rds_sg_id         = module.sg.rds_sg_id
  db_port           = 5432
  instance_class    = local.instance_class
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.rds_subnet_ids
}



#6 IAM Role

module "iam_role" {
  source = "./modules/iam"

  env                            = local.env
  project                        = local.project
  artifact_bucket_arn            = module.s3.artifact_bucket_arn
  db_secret_arn                  = module.rds.db_secret_arn
  cloudwatch_agent_parameter_arn = module.ssm.cloudwatch_agent_parameter_arn
  db_parameter_host              = module.ssm.db_host_arn
  db_parameter_port              = module.ssm.db_port_arn
  current_version                = module.ssm.backend_current_version_arn
  db_parameter_secret_arn        = module.ssm.db_secret_arn

}



#7 Web ALC 

module "web_acl" {
  source = "./modules/waf"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
  env     = local.env
  project = local.project
}


#8 CloudFront

module "cloudfront" {
  source = "./modules/cloudfront"

  env                 = local.env
  project             = local.project
  origin              = "s3"
  bucket              = module.s3.frontend_bucket
  alb                 = module.alb.alb_dns
  path_pattern        = "/api/*"
  web_acl_id          = module.web_acl.web_acl_arn
  default_root_object = "index.html"
  bucket_id           = "frontend-s3"
  alb_id              = "backend-alb"
}


#9 SSM Parameters

module "ssm" {
  source  = "./modules/ssm"
  env     = local.env
  project = local.project

  db_host         = module.rds.db_host
  db_port         = module.rds.db_port
  db_secret_arn   = module.rds.db_secret_arn
  current_version = var.current_version
  db_name         = module.rds.db_name
}


#10 S3

module "s3" {
  source = "./modules/s3"

  env     = local.env
  project = local.project
}


#11 CloudWatch Alarms

module "cloudwatch" {
  source                      = "./modules/cloudwatch"
  env                         = local.env
  project                     = local.project
  sns_topic_arn               = module.sns_topic.sns_topic_arn
  alb_arn_suffix              = module.alb.lb_suffix
  target_group_arn_suffix     = module.alb.target_group_suffix
  asg_name                    = module.asg.asg_name
  instance_capacity_threshold = 2
  alb_rejected_connections    = 10
  alb_5xx_threshold           = 10
  alb_threshold               = 0
  cpu_threshold               = 70
  memory_threshold            = 70
  disk_threshold              = 70
}


#12 SNS Notification

module "sns_topic" {
  source  = "./modules/sns"
  env     = local.env
  project = local.project
  email   = local.email
}