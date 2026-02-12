# General Variables

variable "deployment-config" {
  type        = string
  description = "deployment configuration type for codedeploy"
}

# Module Variables 

variable "tg-arn-blue" {
  type        = string
  description = "ALB blue target group arn"
}

variable "tg-arn-green" {
  type        = string
  description = "ALB green target group arn"
}

variable "lb-listener-arn" {
  type        = string
  description = "ALB listener arn"
}

variable "ecs-service-name" {
  type        = string
  description = "The ECS service name"
}

variable "ecs-cluster-name" {
  type        = string
  description = "The ECS service name"
}