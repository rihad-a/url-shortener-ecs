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
        name = var.tg-blue-name
      } 
 
      target_group { 
        name = var.tg-green-name
      } 
    } 
  } 
} 

# Codedeploy IAM resources

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "codedeploy" {

  statement {
    sid    = "ECSPolicy"
    effect = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:CreateTaskSet",
      "ecs:DeleteTaskSet",
      "ecs:UpdateServicePrimaryTaskSet"
    ]
    resources = [
      "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:service/${var.ecs-cluster-name}/${var.ecs-service-name}",
      "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task-set/${var.ecs-cluster-name}/${var.ecs-service-name}/*"
    ]
  }

  statement {
    sid    = "ELBPolicy"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:ModifyRule"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "PassRolePolicy"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskRole"
    ]
  }
}

resource "aws_iam_role" "codedeploy" {
  name = "codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "codedeploy.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codedeploy" {
  name   = "codedeploy-policy"
  role   = aws_iam_role.codedeploy.id
  policy = data.aws_iam_policy_document.codedeploy.json
}

resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = var.ecs-service-name
}
