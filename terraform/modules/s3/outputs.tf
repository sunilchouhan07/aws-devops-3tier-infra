output "artifact_bucket_name" {
  value = aws_s3_bucket.app_artifacts.bucket
}

output "artifact_bucket_arn" {
  value = aws_s3_bucket.app_artifacts.arn
}

output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend_build.bucket
}

output "frontend_bucket" {
  value = aws_s3_bucket.frontend_build.bucket_regional_domain_name
}

output "frontend_bucket_arn" {
  value = aws_s3_bucket.frontend_build.arn
}

output "frontend_bucket_id" {
  value = aws_s3_bucket.frontend_build.id
}
