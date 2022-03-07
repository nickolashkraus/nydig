# -----------------------------------------------------------------------------
# IAM ROLE DELEGATION
# This Terraform module is part of the hub-and-spoke model for IAM role
# delegation.
#
# GitHub: infrastrucuture-core-iam
#
# * Each IAM role in a spoke account must grant access to the administrative
#   AWS account, which creates a trust relationship with the administrative
#   AWS account, so that its users may assume the role.
#
# * The IAM role in the hub account must also have a policy that creates the
#   converse relationship, allowing this role to assume each role in the spoke
#   accounts.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# IAM ROLE (HUB)
# -----------------------------------------------------------------------------
resource "aws_iam_role" "hub" {
  name               = var.hub_role_name
  assume_role_policy = data.aws_iam_policy_document.hub_assume_role_policy.json
}

data "aws_iam_policy_document" "hub_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "hub" {
  policy = data.aws_iam_policy_document.additional.json
  role   = aws_iam_role.hub_role.id
}


data "aws_iam_policy_document" "additional" {
  statement {
    actions = ["*"]

    resources = ["*"]
  }
}
