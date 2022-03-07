# -----------------------------------------------------------------------------
# OUTPUTS
# -----------------------------------------------------------------------------
output "s3_bucket" {
  value       = module.s3_backend.s3_bucket
  description = <<-EOF
  The name of the S3 bucket for storing Terraform state
  EOF
}

output "dynamodb_table" {
  value       = module.s3_backend.dynamodb_table
  description = <<-EOF
  The name of the DynamoDB table for storing Terraform state lock
  EOF
}
