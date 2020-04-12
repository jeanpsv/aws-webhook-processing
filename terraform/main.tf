
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = "default"
}

provider "archive" {
  version = "~> 1.3"
}
