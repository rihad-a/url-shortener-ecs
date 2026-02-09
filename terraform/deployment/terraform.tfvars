# AWS Tags Variable
aws_tags = {

Environment                            = "dev"
Project                                = "ecs"
Owner                                  = "rihad"
Terraform                              = "true"

}

# General Variables
domain_name                              = "networking.rihad.co.uk"
application-port                         = 3000

# AWS VPC Variables
vpc-cidr                                 = "10.0.0.0/16"
subnet-cidrblock-pub1                    = "10.0.101.0/24"
subnet-cidrblock-pub2                    = "10.0.102.0/24"
subnet-cidrblock-pri1                    = "10.0.1.0/24"
subnet-cidrblock-pri2                    = "10.0.2.0/24"
subnet-az-2a                             = "eu-west-2a"
subnet-az-2b                             = "eu-west-2b"
routetable-cidr                          = "0.0.0.0/0"
subnet-map_public_ip_on_launch_public    = true
subnet-map_public_ip_on_launch_private   = false

# ECS Variables
ecs-container-name                       = "container"
ecs-image                                = "291759414346.dkr.ecr.eu-west-2.amazonaws.com/ecs-project:latest"
ecs-dockerport                           = 3000
ecs-memory                               = 2048
ecs-cpu                                  = 1024
ecs-desiredcount                         = 2