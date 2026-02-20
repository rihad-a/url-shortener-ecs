# Output variables to be used in other modules

output "ecs-service-name" {
  description = "The ECS service name"
  value       = aws_ecs_service.ecs-project.name
}

output "ecs-cluster-name" {
  description = "The ECS service name"
  value       = aws_ecs_cluster.ecs-project.name
}