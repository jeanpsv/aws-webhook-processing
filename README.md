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