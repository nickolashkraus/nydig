# -----------------------------------------------------------------------------
# IAM ROLE DELEGATION
# This Terraform module is part of the hub-and-spoke model for IAM role
# delegation.
#
# GitHub: infrastructure-core-iam
#
# * Each IAM role in a spoke account must grant access to the administrative
#   AWS account, which creates a trust relationship with the administrative
#   AWS account, so that its users may assume the role.
#
# * The IAM role in the hub account must also have a policy that creates the
#   converse relationship, allowing this role to assume each role in the spoke
#   accounts.
# -----------------------------------------------------------------------------

data "aws_iam_role" "hub" {
  name = var.hub_role_name
}

# -----------------------------------------------------------------------------
# IAM ROLE (SPOKE)
# -----------------------------------------------------------------------------
resource "aws_iam_role" "spoke_role" {
  name               = var.spoke_role_name
  assume_role_policy = data.aws_iam_policy_document.cross_account_assume_role_policy.json
}

# -----------------------------------------------------------------------------
# CROSS ACCOUNT ASSUME ROLE POLICY DOCUMENT
# This trust policy allows the 'Hub' role in the source account to assume the
# 'spoke' role in the destination account.
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "cross_account_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      # This role must already exist in the 'source' account or the following
      # error is returned on `terraform apply`:
      #
      # Error: Error creating IAM Role [...]: MalformedPolicyDocument: Invalid
      # principal in policy: [...]
      identifiers = [data.aws_iam_role.hub.arn]
    }
  }
}

resource "aws_iam_role_policy" "spoke" {
  policy = data.aws_iam_policy_document.additional.json
  role   = aws_iam_role.spoke_role.id
}

data "aws_iam_policy_document" "additional" {
  statement {
    actions = ["*"]

    resources = ["*"]
  }
}
