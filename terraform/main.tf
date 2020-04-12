
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = "default"
}

provider "archive" {
  version = "~> 1.3"
}

resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "jeanpsv-aws-webhook-processing"
  region = "us-east-1"
  versioning {
    enabled = true
  }
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    app = "webhook-processing"
  }
}
