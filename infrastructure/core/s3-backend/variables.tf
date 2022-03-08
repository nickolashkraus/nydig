# -----------------------------------------------------------------------------
# REQUIRED VARIABLES
# -----------------------------------------------------------------------------
variable "s3_bucket" {
  type        = string
  description = <<-EOF
  Name of the Amazon S3 bucket to store Terraform state.
  EOF
}

variable "dynamodb_table" {
  type        = string
  description = <<-EOF
  Name of the DynamoDB table to store Terraform state lock.
  EOF
}
