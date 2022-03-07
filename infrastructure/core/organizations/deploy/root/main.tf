# -----------------------------------------------------------------------------
# AWS ORGANIZATIONS
# Deploy 'organizations' Terraform module to 'root' AWS account.
# -----------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

module "organizations" {
  source = "../../modules/organizations"

  /* Add variables here... */
}