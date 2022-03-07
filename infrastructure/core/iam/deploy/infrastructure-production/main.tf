# -----------------------------------------------------------------------------
# IAM ROLE DELEGATION
# Deploy 'iam' Terraform modules to 'infrastructure-production' AWS account.
# -----------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

module "hub" {
  source = "../../modules/hub"
}

module "spoke" {
  source = "../../modules/spoke"
}

terraform {
  backend "s3" {
    /* Configure S3 backend... */
  }
}
