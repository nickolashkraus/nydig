# -----------------------------------------------------------------------------
# SPLUNK ENTERPRISE
# Deploy 'splunk-enterprise' Terraform module.
# -----------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

module "splunk_enterprise" {
  source = "../"
  /* Add variables here... */
}
