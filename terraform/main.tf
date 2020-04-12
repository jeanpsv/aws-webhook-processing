
provider "aws" {
  version    = "~> 2.0"
  region     = "us-east-1"
  access_key = "accesskey"
  secret_key = "secretkey"
  profile    = "default"
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
