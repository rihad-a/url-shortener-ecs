# Creating a WAF

resource "aws_wafv2_web_acl" "ecs-waf" {
  name        = "ecs-waf"
  description = "ECS managed rule for a WAF."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "SizeRestrictions_QUERYSTRING"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "NoUserAgent_HEADER"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}

# Connecting WAF to ALB
resource "aws_wafv2_web_acl_association" "alb_association" {
  resource_arn = var.alb-arn
  web_acl_arn  = aws_wafv2_web_acl.ecs-waf.arn
}