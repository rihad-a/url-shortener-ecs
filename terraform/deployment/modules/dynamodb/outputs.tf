# Output variables to be used in other modules

output "tg_arn" {
  description = "ALB target group arn"
  value       = aws_lb_target_group.alb-tg.arn
}

output "alb_dns" {
  description = "ALB dns name"
  value       = aws_lb.terraform-alb.dns_name
}

output "alb_zoneid" {
  description = "ALB zone id"
  value       = aws_lb.terraform-alb.zone_id
}