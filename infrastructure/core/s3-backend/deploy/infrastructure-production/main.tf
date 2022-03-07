# -----------------------------------------------------------------------------
# AWS ORGANIZATIONS
# Deploy 's3_backend' Terraform module to 'infrastructure-production' AWS
# account.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# AMAZON S3 BUCKET AND DYNAMODB TABLE FOR STORING TERRAFORM STATE
# -----------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

module "s3_backend" {
  source         = "../../modules/s3-backend"
  s3_bucket      = "terraform-state-nydig"
  dynamodb_table = "terraform-state-nydig"
}
