# -----------------------------------------------------------------------------
# AMAZON VPC AND SUBNETS
# This Terraform module deploys a non-default VPC with private and public
# subnets.
#
# It includes the following:
#   * VPC with private and public subnets
#   * VPC Peering
#
# GitHub: infrastructure-core-vpc
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"
}

/* Do CIDR block calculations here...
 *
 * NOTE: Use cidrsubnets function:
 *   * https://www.terraform.io/language/functions/cidrsubnets
 */

# -----------------------------------------------------------------------------
# VPC
# -----------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_vpc_dhcp_options" "options" {}
resource "aws_vpc_dhcp_options_association" "association" {}
resource "aws_internet_gateway" "internet_gateway" {}
resource "aws_vpc_endpoint" "vpc_endpoint" {}

# -----------------------------------------------------------------------------
# VPC PEERING
# -----------------------------------------------------------------------------

resource "aws_vpc_peering_connection" "connection" {}

resource "aws_vpc_peering_connection_accepter" "connection" {
  provider = aws.us-east-1
}

# To send private IPv4 traffic from your instance to an instance in a peer VPC,
# you must add a route to the route table that's associated with your subnet in
# which your instance resides. The route points to the CIDR block (or portion
# of the CIDR block) of the peer VPC in the VPC peering connection, and
# specifies the VPC peering connection as the target.
resource "aws_route" "vpc_peering_connection" {}

/* Add additional VPC peering connections... */

# -----------------------------------------------------------------------------
# VPC FLOW LOGS
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "log_group" {}
resource "aws_flow_log" "flow_log" {}

resource "aws_iam_role" "iam_role" {
  name = "flow-log"
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name = "flow-log"
}

# -----------------------------------------------------------------------------
# PRIVATE SUBNETS
# -----------------------------------------------------------------------------
resource "aws_subnet" "private" {
  for_each                = { for zone in availability_zones : zone.name => zone }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.private
  availability_zone       = each.value.zone
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {}
resource "aws_route" "private" {}
resource "aws_network_acl" "private" {}
resource "aws_route_table_association" "private" {}

resource "aws_eip" "eip" {}
resource "aws_nat_gateway" "nat_gateway" {}
resource "aws_route" "nat_gateway" {}

# -----------------------------------------------------------------------------
# PUBLIC SUBNETS
# -----------------------------------------------------------------------------
resource "aws_subnet" "public" {
  for_each                = { for zone in availability_zones : zone.name => zone }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.public
  availability_zone       = each.value.zone
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {}
resource "aws_route" "public" {}
resource "aws_network_acl" "public" {}
resource "aws_route_table_association" "public" {}

