
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "jeanpsv-aws-webhook-processing"
    key    = "terraform/state"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "jeanpsv-aws-webhook-processing"
  region = "us-east-1"
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    app = "webhook-processing"
  }
}
