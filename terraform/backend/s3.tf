resource "aws_s3_bucket" "state_bucket" {
  bucket = "three-tier-state"

  tags = {
    Name = "Backend"
  }
}