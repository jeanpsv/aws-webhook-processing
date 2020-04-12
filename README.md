# aws-webhook-processing
Create infrastructure on AWS to handle webhooks with reliability

## Getting Started

### Download Terraform client

- [Terraform Download Page](https://www.terraform.io/downloads.html)
- [Terraform cli documentation](https://www.terraform.io/docs/cli-index.html)

### Create Terraform configuration

create file `terraform/main.tf` and add:

```terraform
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = "default"
}
```

after file creation, run:

```sh
$ cd terraform
$ terraform init
```

### Create AWS user

create [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) on [AWS IAM](https://aws.amazon.com/pt/iam/) and set:

- access type: Programmatic access
- policies: AdministratorAccess

save `access_key` and `secret_key`


### Configure AWS Provider authentication

run the commands below replacing values for your access and secret keys:

```sh
$ export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
```

### Create bucket to storage Terraform state

add in `terraform/main.tf` the content below:

```terraform
resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "YOUR_BUCKET_NAME"
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
```

- change `"YOUR_BUCKET_NAME"` for a name you want.
- `tags` are opcional and you can set the values you want.

### Let's apply Terraform changes

run the commands below:

```sh
$ terraform plan
$ terraform apply
```