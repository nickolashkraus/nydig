# -----------------------------------------------------------------------------
# AWS ORGANIZATIONS
# Deploy 'organizations' Terraform module to 'root' AWS account.
# -----------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

module "organizations" {
  source = "../../"
  /* Add variables here... */
}

terraform {
  backend "s3" {
    /* Configure S3 backend... */
  }
}
