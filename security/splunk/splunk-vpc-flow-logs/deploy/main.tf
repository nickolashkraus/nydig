# -----------------------------------------------------------------------------
# SPLUNK VPC FLOW LOGS
# Deploy 'splunk-vpc-flow-logs' Terraform module.
# -----------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

module "splunk-vpc-flow-logs" {
  source = "../"
  /* Add variables here... */
}
