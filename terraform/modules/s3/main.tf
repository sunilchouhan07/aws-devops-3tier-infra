resource "aws_s3_bucket" "app_artifacts" {
  bucket = "${var.project}-${var.env}-artifacts"

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



data "aws_iam_policy_document" "frontend_bucket_policy" {

  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "aws_s3_bucket.frontend_build.arn/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        var.cloudfront_distribution_arn
      ]
    }
  }
}


resource "aws_s3_bucket_policy" "frontend" {

  bucket = aws_s3_bucket.frontend_build.id

  policy = data.aws_iam_policy_document.frontend_bucket_policy.json

  depends_on = [
    aws_s3_bucket_public_access_block.frontend
  ]
}