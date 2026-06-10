locals {
  env = terraform.workspace
}

locals {
  instance_type_map = {
    dev  = "t3.micro"
    stg  = "t3.micro"
    prod = "t3.small"
  }

  # ami_id_map = {
  #   dev = "ami-0ecb62995f68bb549"
  #   stg = "ami-068c0051b15cdb816"
  #   prod = "ami-0ecb62995f68bb549"
  # }

  rbd_size_map = {
    dev  = 10
    stg  = 10
    prod = 20
  }

  allocated_storage_map = {
    dev  = 10
    stg  = 10
    prod = 20
  }

  instance_class_map = {
    dev  = "db.t3.micro"
    stg  = "db.t3.micro"
    prod = "db.t4g.micro"
  }

  db_name_map = {
    dev  = "dev_db"
    stg  = "stg_db"
    prod = "prod_db"
  }

  username_map = {
    dev  = "dev_admin"
    stg  = "stg_admin"
    prod = "prod_admin"
  }

  common_tags = {
    Project = "aws-devops-3tier-infra"
    Owner   = "Sunil"
    Env     = terraform.workspace
    Managed = "Terraform"
  }

  rbd_size          = local.rbd_size_map[terraform.workspace]
  username          = local.username_map[terraform.workspace]
  db_name           = local.db_name_map[terraform.workspace]
  instance_class    = local.instance_class_map[terraform.workspace]
  allocated_storage = local.allocated_storage_map[terraform.workspace]
  tags              = local.common_tags
  instance_type     = local.instance_type_map[terraform.workspace]
}
