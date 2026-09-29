output "cloudfront_distribution_dns" {
  value = module.cloudfront.distribution_domain_name
}

output "artifact_bucket_name" {
  value = module.s3.artifact_bucket_name
}

output "frontend_bucket_name" {
  value = module.s3.frontend_bucket_name
}