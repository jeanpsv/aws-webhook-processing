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
  version    = "~> 2.0"
  region     = "us-east-1"
  profile    = "default"
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

add access and secret key in aws provider configuration

```terraform
provider "aws" {
  version    = "~> 2.0"
  region     = "us-east-1"
  access_key = "aws iam user access key"
  secret_key = "aws iam user secret key"
  profile    = "default"
}
```