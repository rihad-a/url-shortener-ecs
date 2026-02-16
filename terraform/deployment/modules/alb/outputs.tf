# Output variables to be used in other modules

output "tg-blue-name" {
  description = "ALB blue target group name"
  value       = aws_lb_target_group.alb-tg-blue.name
}

output "tg-green-name" {
  description = "ALB green target group name"
  value       = aws_lb_target_group.alb-tg-green.name
}

output "tg-blue-arn" {
  description = "ALB blue target group arn"
  value       = aws_lb_target_group.alb-tg-blue.arn
}


output "alb_dns" {
  description = "ALB dns name"
  value       = aws_lb.terraform-alb.dns_name
}

output "alb_zoneid" {
  description = "ALB zone id"
  value       = aws_lb.terraform-alb.zone_id
}

output "lb-listener-arn" {
  description = "ALB listener arn"
  value       = aws_lb_listener.alb_listener_https.arn
}

