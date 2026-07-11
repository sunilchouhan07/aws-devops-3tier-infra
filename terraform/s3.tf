module "s3" {
  source = "./modules/s3"

  env = local.env
}