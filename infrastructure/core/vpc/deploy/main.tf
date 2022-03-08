# -----------------------------------------------------------------------------
# AMAZON VPC AND SUBNETS
# Deploy 'vpc' Terraform module to multiple regions in all AWS accounts.
# -----------------------------------------------------------------------------

# /!\ WARNING /!\: You cannot create a VPC peering connection between VPCs with
# matching or overlapping IPv4 CIDR blocks. For this reason, the entire network
# IP space must be know beforehand.

/* Do CIDR block calculations here...
 *
 * NOTE: Use cidrsubnets function:
 *   * https://www.terraform.io/language/functions/cidrsubnets
 */

# VPC CIDR Management
#
# Each AWS account is allocated a /16 IPv4 CIDR block (10.0.0.0/16). This
# provides up to 65,536 private IPv4 addresses.
#
# This CIDR block is further subdivided in order to accommodate multiple
# regions within each AWS account. It should be noted that the entire CIDR
# block is not allocated in order to account for future regions:
#
#   * 10.0.0.0/20  -> us-east-1    (4096 IPv4 addresses)
#   * 10.0.16.0/20 -> ap-south-1   (4096 IPv4 addresses)
#   * 10.0.32.0/20 -> eu-central-1 (4096 IPv4 addresses)
#   * 10.0.48.0/20 -> sa-east-1    (4096 IPv4 addresses)
#
# The CIDR blocks are divided again in order to allocate IP space for both
# private and public subnets:
#
#   * 10.0.0.0/24 -> (us-east-1a) private (256 IPv4 addresses)
#   * 10.0.1.0/24 -> (us-east-1b) private (256 IPv4 addresses)
#   * 10.0.2.0/24 -> (us-east-1c) private (256 IPv4 addresses)
#   * 10.0.3.0/24 -> (us-east-1d) private (256 IPv4 addresses)
#   * 10.0.4.0/24 -> (us-east-1a) public  (256 IPv4 addresses)
#   * 10.0.5.0/24 -> (us-east-1b) public  (256 IPv4 addresses)
#   * 10.0.6.0/24 -> (us-east-1c) public  (256 IPv4 addresses)
#   * 10.0.7.0/24 -> (us-east-1d) public  (256 IPv4 addresses)

# Deploy to NAMER
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# Deploy to APAC
provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}

# Deploy to EMEA
provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

# Deploy to LATAM
provider "aws" {
  alias  = "sa-east-1"
  region = "sa-east-1"
}

module "vpc-us-east-1" {
  source = "../"
  providers = {
    aws = aws.us-east-1
  }
  /* Add variables here... */
}

module "vpc-ap-south-1" {
  source = "../"
  providers = {
    aws = aws.ap-south-1
  }
  /* Add variables here... */
}

module "vpc-eu-central-1" {
  source = "../"
  providers = {
    aws = aws.eu-central-1
  }
  /* Add variables here... */
}

module "vpc-sa-east-1" {
  source = "../"
  providers = {
    aws = aws.sa-east-1
  }
  /* Add variables here... */
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
