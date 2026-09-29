resource "aws_s3_bucket" "app_artifacts" {
  bucket = "${var.project}-${var.env}-artifacts-2026"

  tags = {
    Name        = "${var.project}-${var.env}-artifacts"
    Environment = var.env
    Project     = var.project
    Purpose     = "Application Artifact"
  }
}


resource "aws_s3_bucket" "frontend_build" {
  bucket = "${var.project}-${var.env}-ems-bucket"

  tags = {
    Name        = "${var.project}-${var.env}-ems-bucket"
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend_build.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend_build.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend_build.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend_build.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

