# -----------------------------------------------------------------------------
# OUTPUTS
# -----------------------------------------------------------------------------
output "s3_bucket" {
  value       = aws_s3_bucket.s3_bucket.id
  description = "The name of the S3 bucket"
}

output "dynamodb_table" {
  value       = aws_dynamodb_table.dynamodb_table.id
  description = "The name of the DynamoDB table"
}
