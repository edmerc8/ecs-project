resource "aws_wafv2_web_acl" "lb_waf" {
  name        = "alb-waf"
  description = "WAF linked to the application load balancer"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Protect against known bad actors
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 0
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPReputationMetric"
      sampled_requests_enabled   = true
    }
  }

  # For DDOS protection
  rule {
    name     = "IPLimitRequests"
    priority = 10
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPLimitRequestsMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 100
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ManagedCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WebACL"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "example" {
  resource_arn            = aws_wafv2_web_acl.lb_waf.arn
  log_destination_configs = [var.waf_logs_bucket]

  depends_on = [var.waf_logs_bucket_policy]
}

resource "aws_wafv2_web_acl_association" "lb_waf_association" {
  resource_arn = var.lb_resource
  web_acl_arn  = aws_wafv2_web_acl.lb_waf.arn
}
