# General Variables

variable "deployment-config" {
  type        = string
  description = "deployment configuration type for codedeploy"
}


# Module Variables 

variable "tg-blue-name" {
  type        = string
  description = "ALB blue target group name"
}

variable "tg-green-name" {
  type        = string
  description = "ALB green target group name"
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