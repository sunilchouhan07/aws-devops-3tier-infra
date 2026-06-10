resource "aws_s3_bucket" "state_bucket" {
  bucket = "backend-state-bucket-2026"

  tags = {
    Name = "Backend"
  }
}