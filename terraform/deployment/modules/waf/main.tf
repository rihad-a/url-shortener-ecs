# Creating a WAF

resource "aws_wafv2_web_acl" "alb-waf" {
  name        = var.waf-name
  description = "WAF for ALB protection"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "RateLimitRule"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.waf-metric-name
    sampled_requests_enabled   = true
  }  
}

# Connecting WAF to ALB
resource "aws_wafv2_web_acl_association" "alb_association" {
  resource_arn = var.alb-arn
  web_acl_arn  = aws_wafv2_web_acl.alb-waf.arn
}