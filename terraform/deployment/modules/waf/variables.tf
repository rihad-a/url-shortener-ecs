# WAF Variables

variable "waf-name" {
  type        = string
  description = "The name of the WAF"
}

variable "waf-metric-name" {
  type        = string
  description = "The name of the metric for logs"
}

# Module Variables

variable "alb-arn" {
  type        = string
  description = "ALB  arn"
}