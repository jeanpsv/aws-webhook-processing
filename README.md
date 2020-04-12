# aws-webhook-processing
Create infrastructure on AWS to handle webhooks with reliability

## Getting Started

### Download Terraform client

- [Terraform Download Page](https://www.terraform.io/downloads.html)
- [Terraform cli documentation](https://www.terraform.io/docs/cli-index.html)

### Create AWS user

create [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) on [AWS IAM](https://aws.amazon.com/pt/iam/) and set:

- access type: Programmatic access
- policies: AdministratorAccess

save `access_key` and `secret_key`


### Configure AWS Provider authentication

run the commands below replacing values for your access and secret keys:

```sh
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
```

### Let's apply Terraform changes

run the commands below:

```sh
$ terraform plan
$ terraform apply
```