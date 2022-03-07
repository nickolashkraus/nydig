# -----------------------------------------------------------------------------
# IAM ROLE DELEGATION
# Deploy 'iam' Terraform modules to 'infrastructure-development' AWS account.
# -----------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

module "spoke" {
  source = "../../modules/spoke"
}

terraform {
  backend "s3" {
    /* Configure S3 backend... */
  }
}
