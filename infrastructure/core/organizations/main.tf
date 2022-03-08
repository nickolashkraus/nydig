# -----------------------------------------------------------------------------
# AWS ORGANIZATIONS
# This Terraform module creates organizational units (OU) within the root
# AWS account.
#
# GitHub: infrastructure-core-organizations
#
# Organzational Units:
#   * Product
#   * Infrastructure
#   * Security
#
# AWS Accounts:
#   * Product
#     ├── Development
#     └── Production
#   * Infrastructure
#     ├── Development
#     └── Production
#   * Security
#     ├── Development
#     └── Production
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"
}

resource "aws_organizations_organization" "organization" {
  aws_service_access_principals = []

  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "product" {
  name      = "Product"
  parent_id = aws_organizations_organization.product.roots[0].id
}

resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "Infrastructure"
  parent_id = aws_organizations_organization.infrastructure.roots[0].id
}

resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organization.security.roots[0].id
}

resource "aws_organizations_account" "product_development" {
  name      = "Product-Development"
  email     = "first.last@nydig.com"
  parent_id = aws_organizations_organizational_unit.product.id
}

resource "aws_organizations_account" "product_production" {
  name      = "Product-Production"
  email     = "first.last@nydig.com"
  parent_id = aws_organizations_organizational_unit.product.id
}

resource "aws_organizations_account" "infrastructure_development" {
  name      = "Infrastructure-Development"
  email     = "first.last@nydig.com"
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_account" "infrastructure_production" {
  name      = "Infrastructure-Production"
  email     = "first.last@nydig.com"
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_account" "security_development" {
  name      = "Security-Development"
  email     = "first.last@nydig.com"
  parent_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_account" "security_production" {
  name      = "Security-Production"
  email     = "first.last@nydig.com"
  parent_id = aws_organizations_organizational_unit.security.id
}
