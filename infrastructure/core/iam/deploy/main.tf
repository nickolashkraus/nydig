# -----------------------------------------------------------------------------
# IAM ROLE DELEGATION
# Deploy 'iam' Terraform modules to all AWS accounts.
#
# NOTE: Only deploy 'hub' Terraform module to Infrastructure-Production AWS
# account. Deploy 'spoke' Terraform module to all AWS accounts expect
# Infrastructure-Production.
# -----------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

data "aws_iam_account_alias" "current" {}

# Only deploy 'hub' Terraform module to Infrastructure-Production AWS account.
module "hub" {
  count  = data.aws_iam_account_alias.current.account_alias == "Infrastructure-Production" ? 1 : 0
  source = "../../modules/hub"
}

# Deploy 'spoke' Terraform module to all AWS accounts expect Infrastructure-Production.
module "spoke" {
  count  = data.aws_iam_account_alias.current.account_alias != "Infrastructure-Production" ? 1 : 0
  source = "../../modules/spoke"
}

# NOTE: Since this module is deployed to *all* AWS accounts, we cannot hardcode
# the backend configuration. Instead, the backend is configured dynamically at
# runtime.
#
# Example:
#
#   $ terraform init -reconfigure \
#     -backend-config="bucket=bucket" \
#     -backend-config="key=path/to/key/terraform.tfstate" \
#     -backend-config="dynamodb_table=table"
#
# terraform {
#   backend "s3" {
#     /* Configure S3 backend... */
#   }
# }
