# Creating an ECS cluster and attaching execution role

resource "aws_ecs_cluster" "ecs-project" {
  name = "ecs-project"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

# Assigning a task definition

resource "aws_ecs_task_definition" "ecs-docker" {
  family                   = "ecs-docker"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs-cpu
  memory                   = var.ecs-memory
  execution_role_arn       = "${data.aws_iam_role.ecs_task_execution_role.arn}"
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
    target_group_arn = var.tg_arn
    container_name   = var.ecs-container-name
    container_port   = var.ecs-dockerport
  }

  network_configuration {
   subnets         = [var.subnetpri1_id]
   security_groups = [aws_security_group.sg2.id]
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

