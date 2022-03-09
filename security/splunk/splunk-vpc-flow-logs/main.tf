# -----------------------------------------------------------------------------
# VPC FLOW LOGS TO SPLUNK USING AMAZON KINESIS DATA FIREHOSE
# This Terraform module deploys the resources necessary to send VPC flow logs
# to Splunk using Amazon Kinesis Data Firehose.
#
# First you send the Amazon VPC flow logs to Amazon CloudWatch. Then from
# CloudWatch, the data goes to a Kinesis Data Firehose delivery stream. Kinesis
# Data Firehose then invokes an AWS Lambda function to decompress the data, and
# sends the decompressed log data to Splunk.
#
# AWS Documenation:
#   * https://docs.aws.amazon.com/firehose/latest/dev/vpc-splunk-tutorial.html
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"
}

# -----------------------------------------------------------------------------
# STEP 1: SEND LOG DATA FROM AMAZON VPC TO AMAZON CLOUDWATCH
#
# Create an Amazon CloudWatch log group to receive your Amazon VPC flow logs.
# Then, you create flow logs for your Amazon VPC and send them to the
# CloudWatch log group that you created.
#
# AWS Documenation:
#   * https://docs.aws.amazon.com/firehose/latest/dev/log-data-from-vpc-to-cw.html
# -----------------------------------------------------------------------------

/* VPC flow log configuration is managed by the 'vpc' Terraform module. */

# -----------------------------------------------------------------------------
# STEP 2: CREATE A KINESIS DATA FIREHOSE DELIVERY STREAM WITH SPLUNK AS A
# DESTINATION
#
# Create an Amazon Kinesis Data Firehose delivery stream to receive the log
# data from Amazon CloudWatch and deliver that data to Splunk.
#
# The logs that CloudWatch sends to the delivery stream are in a compressed
# format. However, Kinesis Data Firehose can't send compressed logs to Splunk.
# Therefore, when you create the delivery stream in the following procedure,
# you enable data transformation and configure an AWS Lambda function to
# uncompress the log data. Kinesis Data Firehose then sends the uncompressed
# data to Splunk.
#
# AWS Documenation:
#   * https://docs.aws.amazon.com/firehose/latest/dev/creating-the-stream-to-splunk.html
# -----------------------------------------------------------------------------
resource "aws_kinesis_firehose_delivery_stream" "delivery_stream" {
  name        = "splunk"
  destination = "splunk"

  s3_configuration {}

  splunk_configuration {}
}

resource "aws_iam_role" "lambda" {}
resource "aws_iam_role_policy" "lambda" {}
resource "aws_lambda_function" "lambda" {}

# -----------------------------------------------------------------------------
# STEP 3: SEND THE DATA FROM AMAZON CLOUDWATCH TO KINESIS DATA FIREHOSE
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# STEP 4: CHECK THE RESULTS IN SPLUNK AND IN KINESIS DATA FIREHOSE
# -----------------------------------------------------------------------------
