module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  env      = local.env
  public_subnets = {
    pub_sub1 = {
      cidr = "10.0.1.0/24"
      az   = "ap-south-1a"
    }

    pub_sub2 = {
      cidr = "10.0.2.0/24"
      az   = "ap-south-1b"
    }

  }
  private_subnets_app = {
    pri_sub1 = {
      cidr = "10.0.3.0/24"
      az   = "ap-south-1a"
    }

    pri_sub2 = {
      cidr = "10.0.4.0/24"
      az   = "ap-south-1b"
    }

  }
  private_subnets_rds = {
    pri_sub3 = {
      cidr = "10.0.5.0/24"
      az   = "ap-south-1a"
    }

    pri_sub4 = {
      cidr = "10.0.6.0/24"
      az   = "ap-south-1b"
    }

  }
  nat_subnet_name = "pub_sub1"
}