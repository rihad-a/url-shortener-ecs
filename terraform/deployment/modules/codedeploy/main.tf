# Setting up Codedeploy 

resource "aws_codedeploy_app" "ecs" { 
  compute_platform = "ECS" 
  name             = "ecs" 
} 
 
resource "aws_codedeploy_deployment_group" "ecs" { 
  app_name               = aws_codedeploy_app.ecs.name 
  deployment_group_name  = "deployment-group" 
  deployment_config_name = var.deployment-config 
  service_role_arn       = aws_iam_role.codedeploy.arn 
 
  auto_rollback_configuration { 
    enabled = true 
    events  = ["DEPLOYMENT_FAILURE"] 
  } 
 
  deployment_style { 
    deployment_type   = "BLUE_GREEN" 
    deployment_option = "WITH_TRAFFIC_CONTROL" 
  } 
 
  blue_green_deployment_config { 
    deployment_ready_option { 
      action_on_timeout = "CONTINUE_DEPLOYMENT" 
    } 
 
    terminate_blue_instances_on_deployment_success { 
      action                           = "TERMINATE" 
      termination_wait_time_in_minutes = 5 
    } 
  } 
 
  ecs_service { 
    service_name = var.ecs-service-name
    cluster_name = var.ecs-cluster-name
  } 
 
  load_balancer_info { 
    target_group_pair_info { 
      prod_traffic_route { 
        listener_arns = [var.lb-listener-arn] 
      } 
 
      target_group { 
        name = var.tg-arn-blue
      } 
 
      target_group { 
        name = var.tg-arn-green
      } 
    } 
  } 
} 