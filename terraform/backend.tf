terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }



  backend "s3" {
    bucket         = "backend-state-bucket-2026"
    key            = "terraform/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "State-lock"
    encrypt        = true
  }
}
