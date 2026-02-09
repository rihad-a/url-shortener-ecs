# Creating the main ALB resource

resource "aws_lb" "terraform-alb" {
  name               = "terraform-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg1.id]
  subnets           = [var.subnetpub1_id, var.subnetpub2_id]
}

# Creating the ALB listeners

resource "aws_lb_listener" "alb_listener_https" {
   load_balancer_arn    = aws_lb.terraform-alb.id
   port                 = 443
   protocol             = "HTTPS"
   certificate_arn = var.certificate_arn
   default_action {
    target_group_arn = aws_lb_target_group.alb-tg.id
    type             = "forward"
  }
}

resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.terraform-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Creating the ALB target group

resource "aws_lb_target_group" "alb-tg" {
  name     = "alb-tg"
  port     = var.application-port
  target_type = "ip" 
  protocol = "HTTP"

  vpc_id   = var.vpc_id
}

# Creating the ALB security group group

resource "aws_security_group" "sg1" {
  name = "sg1"
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
