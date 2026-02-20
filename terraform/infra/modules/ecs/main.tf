# Creating an ECS cluster and attaching task and task execution role

resource "aws_ecs_cluster" "ecs-project" {
  name = "ecs-project"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
    name                  = "ecsTaskExecutionRole"
    assume_role_policy    = data.aws_iam_policy_document.assume-role-policy.json

    depends_on = [data.aws_iam_policy_document.assume-role-policy]
}


data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions               = ["sts:AssumeRole"]

    principals {
      type                = "Service"
      identifiers         = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole-policy" {
    role                  = aws_iam_role.ecsTaskExecutionRole.name
    policy_arn            = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecsTaskRole" {
    name                  = "ecsTaskRole"
    assume_role_policy    = data.aws_iam_policy_document.assume-role-policy.json   

    depends_on = [data.aws_iam_policy_document.assume-role-policy]
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "dynamodb-policy" {
    statement {
      effect = "Allow"
      actions = [
        "dynamodb:GetItem",
        "dynamodb:PutItem"
      ]
      resources = [
        "arn:aws:dynamodb:eu-west-2:${data.aws_caller_identity.current.account_id}:table/${var.db-table-name}"
        ]
    }

}

resource "aws_iam_policy" "dynamodb-policy" {
  name   = "dynamodb-policy"
  policy = data.aws_iam_policy_document.dynamodb-policy.json
}

resource "aws_iam_role_policy_attachment" "ecsTaskRole-policy" {
    role                  = aws_iam_role.ecsTaskRole.name
    policy_arn            = aws_iam_policy.dynamodb-policy.arn
}

# Creating a CloudWatch log group

resource "aws_cloudwatch_log_group" "ecs" {
  name = "ecs"

}

# Assigning a task definition

resource "aws_ecs_task_definition" "ecs-docker" {
  family                   = "ecs-docker"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs-cpu
  memory                   = var.ecs-memory
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  task_role_arn            = aws_iam_role.ecsTaskRole.arn
  
  depends_on = [ aws_cloudwatch_log_group.ecs ]
  
  container_definitions    = jsonencode([
    {
      name      = var.ecs-container-name
      image     = var.ecs-image
      essential = true
      portMappings = [
        {
          containerPort = var.ecs-dockerport
          hostPort      = var.ecs-dockerport
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [
        {"name": "TABLE_NAME", "value": "${var.db-table-name}"},
        {"name": "AWS_DEFAULT_REGION", "value": "eu-west-2"}
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

# Creating an ECS service

resource "aws_ecs_service" "ecs-project" {
  name            = "ecs-project"
  cluster         = aws_ecs_cluster.ecs-project.id
  task_definition = aws_ecs_task_definition.ecs-docker.arn
  desired_count   = var.ecs-desiredcount
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = var.tg-blue-arn
    container_name   = var.ecs-container-name
    container_port   = var.ecs-dockerport
  }

  network_configuration {
   subnets         = [var.subnetpri1_id]
   security_groups = [aws_security_group.sg2.id]
 }

  deployment_controller { 
    type = "CODE_DEPLOY" 
  } 

}

# Creating a security group
 
resource "aws_security_group" "sg2" {
  name = "sg2"
  vpc_id = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  ingress {
    from_port        = var.application-port
    to_port          = var.application-port
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }  


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

