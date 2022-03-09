# -----------------------------------------------------------------------------
# DISTRIBUTED SPLUNK ENTERPRISE DEPLOYMENT
# This Terraform module deploys a distributed Splunk Enterprise cluster and
# installs the Splunk Add-on for Amazon Kinesis Firehose.
#
# Splunk Documenation:
#   * https://docs.splunk.com/Documentation/AddOns/released/Firehose/InstallationstepsfordistributedSplunkEnterprise
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"
}

# -----------------------------------------------------------------------------
# RETRIEVE THE HOSTED ZONE ID FOR THE SPLUNK ENTERPRISE DEPLOYMENT
# -----------------------------------------------------------------------------
data "aws_route53_zone" "hosted_zone" {
  name         = var.domain_name
  private_zone = false
}

# -----------------------------------------------------------------------------
# ACM CERTIFICATE
# TLS certificate provisioned by AWS Certificate Manager.
# -----------------------------------------------------------------------------
resource "aws_acm_certificate" "certificate" {
  domain_name = "splunk.${var.domain_name}"
}

# -----------------------------------------------------------------------------
# ACM CERTIFICATE VALIDATION
# Validates the ACM certificate via DNS.
# -----------------------------------------------------------------------------
resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.hosted_zone.id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}

# -----------------------------------------------------------------------------
# ELASTIC LOAD BALANCER
# If your indexers are on AWS Virtual Private Cloud, use an elastic load
# balancer to send data to your indexers.
#
# NOTE: You must use an ELB. Application load balancers and network load
# balancers are not supported.
#
# Splunk Documenation:
#   * https://docs.splunk.com/Documentation/AddOns/released/Firehose/ConfigureanELB
# -----------------------------------------------------------------------------
resource "aws_elb" "splunk" {
  name = "splunk-elb"

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTPS:8088/services/collector/health/1.0"
    interval            = 30
  }
}

# -----------------------------------------------------------------------------
# The following resources are left for the student to implement:
#   * Indexers
#   * Security Groups
# -----------------------------------------------------------------------------
