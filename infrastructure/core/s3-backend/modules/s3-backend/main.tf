# -----------------------------------------------------------------------------
# AMAZON S3 BUCKET AND DYNAMODB TABLE FOR STORING TERRAFORM STATE
# This Terraform module deploys the resources necessary to store Terraform
# state on AWS.
# It includes the following:
#   * Amazon S3 Bucket
#   * DynamoDB Table
#
# GitHub: infrastrucuture-core-s3-backend
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"
}

# -----------------------------------------------------------------------------
# S3 BUCKET
# Contains Terraform state.
# -----------------------------------------------------------------------------
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket

  # Owner gets FULL_CONTROL. No one else has access rights (default).
  acl = "private"

  # It is highly recommended that you enable Bucket Versioning on the S3 bucket
  # to allow for state recovery in the case of accidental deletions and human
  # error.
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

# -----------------------------------------------------------------------------
# DYNAMODB TABLE
# Contains Terraform state lock.
# -----------------------------------------------------------------------------
resource "aws_dynamodb_table" "dynamodb_table" {
  name = var.dynamodb_table

  # billing_mode specifies how you are charged for read and write throughput
  # and how you manage capacity.
  #
  # Valid values include:
  #   * PROVISIONED: Sets the read/write capacity mode to PROVISIONED. AWS
  #     recommends using PROVISIONED for predictable workloads.
  #
  #   * PAY_PER_REQUEST: Sets the read/write capacity mode to PAY_PER_REQUEST.
  #     AWS recommends using PAY_PER_REQUEST for unpredictable workloads.
  #
  # NOTE: If you set billing_mode as PROVISIONED, you must specify
  # read_capacity and write_capacity. If you set billing_mode as
  # PAY_PER_REQUEST, you cannot specify these arguments.
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  hash_key = "LockID"

  # The table must have a partition key named LockID with type of String. If
  # not configured, state locking will be disabled.
  attribute {
    name = "LockID"
    type = "S"
  }
}
